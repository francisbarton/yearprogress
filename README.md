Looking at tweets by @year\_progress 2019-2020
================
December 18, 2020

<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->
<!-- badges: end -->

I was randomly interested in whether there might be patterns in the
amount of interaction with tweets from the **@year\_progress** bot
during 2020 :scream:, and what the shape of the year might look like
compared to 2019.

This gave me a chance to review the current landscape of `R` clients for
the twitter API :disappointed:. After doing this review, I decided it
would be easier and more satisfying for me to script my own access to
[v2 of the
API](https://developer.twitter.com/en/docs/twitter-api/early-access).

This meant more practice with `httr`, error handling, working with lists
with the frankly brilliant [`purrr`
toolkit](https://purrr.tidyverse.org/), and with writing functions.
Happy as a :pig: in :poop:, *tbqhwy*.

It’s also chance for me to try various other things I haven’t really
used before:

-   Creating a GitHub README as an `.Rmd` file (this very file here),
    instead of my usual `.md`, so I might incorporate some output charts
-   Using a couple of [Pandoc’s Markdown
    extensions](https://pandoc.org/MANUAL.html#pandocs-markdown)
    <sup>[1](# "We've got md_extensions: +emoji+bracketed_spans+inline_notes going on in the yaml here")</sup>
-   GitHub Actions (set up using the `usethis` helper function)
-   Making *a whole actual package* :package:, just for a little bit of
    fun like this
-   Learning a bit more about testing with `testthat`
-   Yet more practice at package architecture and requirements, and
    appeasing R CMD check
-   Doing some hopefully nice <span class="sparkle">dataviz</span>
    :bar_chart: with `ggplot2`, which I still don’t feel like I have
    really used *well* yet. My charts usually look way too crappy for my
    liking.

If you suspect that this whole idea was essentially driven by
pre-Christmas/end-of-term task avoidance, angst and procrastination, you
would be correct.

``` r
# Set variables and run overall query -------------------------------------


# Obtained originally by:
# user_id <- get_user_id(username = "year_progress")
# It isn't going to change, so once obtained just hardcode it:
year_progress_id <- "3233484298"


start_2019 <- "2019-01-01T00:00:00Z"

# This doesn't work with the Twitter API
# https://github.com/tidyverse/lubridate/issues/941
# 
# start_2019 <- lubridate::make_datetime(2019) %>% 
#   lubridate::format_ISO8601(usetz = TRUE)


# see `R/get_user_twetes.R` for how this works
dtf <- get_user_twetes(user_id = year_progress_id, start = start_2019) %>%
  compact() %>%
  unpack_list()       # <- in `R/helpers.R`
```

I realised the other day that it would be fine to call a dataframe `dtf`
instead of boring old `df` :smirk:…

<!--html_preserve-->
<blockquote class="twitter-tweet" data-width="550" data-lang="en" data-dnt="true" data-theme="light">
<p lang="und" dir="ltr">
dtf <a href="https://t.co/6fn2QaMSAB">pic.twitter.com/6fn2QaMSAB</a>
</p>
— Fran Barton (@ludictech)
<a href="https://twitter.com/ludictech/status/1338815874770329602?ref_src=twsrc%5Etfw">December
15, 2020</a>
</blockquote>
<!--/html_preserve-->

``` r
glimpse(dtf)
#> Rows: 200
#> Columns: 7
#> $ id            <chr> "1339495580318445570", "1338166812408745987", "133683...
#> $ created_at    <chr> "2020-12-17T09:00:07.000Z", "2020-12-13T17:00:04.000Z...
#> $ text          <chr> "¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦ 96%", "¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦ 95%", "¦¦¦¦¦¦...
#> $ retweet_count <int> 2496, 4224, 2201, 2457, 2557, 2779, 6334, 1608, 1848,...
#> $ reply_count   <int> 69, 122, 58, 140, 97, 102, 177, 48, 64, 52, 52, 68, 4...
#> $ like_count    <int> 16084, 25424, 14174, 17635, 16767, 17684, 31538, 1001...
#> $ quote_count   <int> 387, 1028, 533, 649, 670, 803, 2245, 351, 418, 388, 3...
```

So let’s lick this dataframe into shape so it’s ready for visualising.

.

.

.

.

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/master/examples>.
