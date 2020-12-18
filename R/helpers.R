#' Tidying helper function: rectangularises a nested list
#'
#' @importFrom dplyr tibble
#' @importFrom tidyr unnest_wider
#' @importFrom rlang .data
#'
#' @param lst a list (presumably nested)
#'
#' @return a tibble




# Tidying helper functions ------------------------------------------------


# Discovered that this can just be done with purrr::compact()
# remove_nulls <- function(lst) {
#   lst %>%
#     map_lgl(~ !is.null(.)) %>%
#     which(.) %>%
#     `[`(lst, .)
# }

unpack_list <- function(lst) {
  lst %>%
    # purrr::map_df(unlist) # a quicker way but less tidy! Instead:
    dplyr::tibble(dat = .data) %>%
    tidyr::unnest_wider(.data[["dat"]]) %>%
    tidyr::unnest_wider(.data[["public_metrics"]])
}


