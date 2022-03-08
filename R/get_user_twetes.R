#' Setup script to retrieve tweets
#'
#' This is a parent script to \code{get_twetes.R}. Here we set the desired fields to return, set up the specific endpoint for the user id we are interested in, deal with authentication and create a query to send to the API.
#'
#' @param user_id Twitter user ID as a string
#' @param start Start date - from when to retrieve tweet data. Needs to be in a particular ISO8601 format like \code{YYYY-MM-DDTHH:mm:ssZ} (check this!)
#'
#' @return list of tweet data
#' @export



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
    tweet.fields = stringr::str_c(return_fields, collapse = ","),
    max_results = 100
  )

  get_twetes(timeline_endpoint, bearer_token_header, api_query)
}


