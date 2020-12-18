#' Setup script to retrieve tweets
#'
#'
#' @importFrom httr GET add_headers stop_for_status status_code content
#' @importFrom purrr pluck flatten possibly
#' @importFrom stringr str_c
#'
#' @param user_id Twitter user ID as a string
#' @param start Start date - from when to retrieve tweet data. Needs to be in a particular ISO8601 format like \code{YYYY-MM-DDTHH:mm:ssZ} (check this!)
#'
#' @return list of tweet data



# TWETES lookup via API ---------------------------------------------------


# parent function (sets overall variables and sets loop running)
get_user_twetes <- function(user_id, start) {
  bearer_token <- Sys.getenv("TWITTER_BEARER_TOKEN")

  # create named vector header for httr
  bearer_token_header <- c(Authorization = paste0("Bearer ", bearer_token))

  # see https://developer.twitter.com/en/docs/
  #     twitter-api/tweets/timelines/api-reference/get-users-id-tweets
  #     for full list of options
  return_fields <- c("created_at", "public_metrics")


  # https://developer.twitter.com/en/docs/
  #      twitter-api/tweets/timelines/api-reference/get-users-id-tweets
  timeline_endpoint <- paste0(
    "https://api.twitter.com/2/users/",
    user_id,
    "/tweets"
  )

  api_query <- list(
    start_time = start,
    tweet.fields = str_c(return_fields, collapse = ","),
    max_results = 100
  )

  possibly(
    get_twetes(timeline_endpoint, bearer_token_header, api_query),
    otherwise = list("Tweets were not successfully retrieved")
  )
}






# internal child function (does loops as necessary)
get_twetes <- function(endpoint, token_header, api_query, lst = NULL) {
  return <- GET(
    endpoint,
    add_headers(token_header),
    query = api_query
  )

  # good practice to include this in functions using httr
  httr::stop_for_status(return)
  # not sure about including this
  # httr::warn_for_status(return)

  # if query is good then extract content using httr
  if (status_code(return) == 200) {
    return_content <- content(return)

    # extract data from query response content...
    content_data <- return_content %>%
      pluck("data")

    # ...and combine with data from previous queries, if any
    if (!is.null(lst)) {
      content_data <- flatten(list(lst, content_data))
    }

    # check for pagination token (means more data to come)
    next_token <- return_content %>%
      pluck("meta", "next_token")

    # if there isn't a token then return the data we've gathered
    if (is.null(next_token)) {
      content_data
    } else {
      # if there is a pagination token then go get the next batch
      # but first: add or update pagination token
      api_query[["pagination_token"]] <- next_token
      get_twetes(endpoint,
        token_header,
        api_query = api_query,
        lst = content_data
      )
    }

    # if the response status wasn't 200 then return what we had
  } else {
    lst
  }
}
