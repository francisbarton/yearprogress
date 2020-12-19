#' Get a twitter user ID for a twitter username
#'
#' Use the Twitter API to find the User ID for a given Twitter username
#'
#' @param username Twitter username as a string (no \code{@} required)
#'
#' @importFrom httr GET add_headers content
#' @importFrom purrr pluck
#'
#' @return the user ID as a string (check! might be as a numeric!)
#' @export



# USER lookup via API -----------------------------------------------------
# https://developer.twitter.com/en/docs/twitter-api/users/lookup/

get_user_id <- function(username) {

  # Authentication --------------------------------------------------------
  # Users reproducing on other machines will need their own token
  # from developer.twitter.com

  # https://developer.twitter.com/en/docs/twitter-api/early-access
  # https://developer.twitter.com/
  #         en/docs/authentication/oauth-2-0/application-only
  # For twitter API v2 apps, bearer token only needed to authenticate
  bearer_token <- Sys.getenv("TWITTER_BEARER_TOKEN")

  # create named vector header for httr
  bearer_token_header <- c(Authorization = paste0("Bearer ", bearer_token))



  paste0(
    "https://api.twitter.com/2/users/by/username/",
    username
  ) %>%
    # get user ID using httr
    GET(add_headers(bearer_token_header)) %>%
    content() %>%
    pluck("data", "id")
}
