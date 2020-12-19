#' Helper function to grab data from the Twitter API
#'
#' Parameters are set by the enclosing parent function \code{get_user_twetes}
#'
#' @param endpoint API endpoint to use
#' @param token_header Authentication header to pass to httr
#' @param api_query query to send to the API
#' @param lst default NULL. Data accumulated so far, to be kept
#'
#' @importFrom purrr pluck flatten
#' @importFrom httr GET content status_code stop_for_status add_headers
#'
#' @return list of tweet data

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
