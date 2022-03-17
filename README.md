
<!-- README.md is generated from README.Rmd. Please edit that file -->

# nyclodging

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

<!-- badges: end -->

`nyclogding` contains shiny application and documentation for analyzing
Airbnb listings in New York City in 2019. It includes:

-   housing price prediction using text data with
    [tidymodels](https://www.tidymodels.org/)

-   spatial analysis and visualization with sf and tmap

-   various user-defined statistical visualization

![](https://github.com/qiushiyan/images/blob/main/nyclodging/screenshot.png?raw=true)

Example dataset:

``` r
nyclodging::listings
#> # A tibble: 48,895 × 15
#>    list_id list_description     host_id host_name neighbourhood_g… neighbourhood
#>      <dbl> <chr>                  <dbl> <chr>     <chr>            <chr>        
#>  1    2539 Clean & quiet apt h…    2787 John      Brooklyn         Kensington   
#>  2    2595 Skylit Midtown Cast…    2845 Jennifer  Manhattan        Midtown      
#>  3    3647 THE VILLAGE OF HARL…    4632 Elisabeth Manhattan        Harlem       
#>  4    3831 Cozy Entire Floor o…    4869 LisaRoxa… Brooklyn         Clinton Hill 
#>  5    5022 Entire Apt: Spaciou…    7192 Laura     Manhattan        East Harlem  
#>  6    5099 Large Cozy 1 BR Apa…    7322 Chris     Manhattan        Murray Hill  
#>  7    5121 BlissArtsSpace!         7356 Garon     Brooklyn         Bedford-Stuy…
#>  8    5178 Large Furnished Roo…    8967 Shunichi  Manhattan        Hell's Kitch…
#>  9    5203 Cozy Clean Guest Ro…    7490 MaryEllen Manhattan        Upper West S…
#> 10    5238 Cute & Cozy Lower E…    7549 Ben       Manhattan        Chinatown    
#> # … with 48,885 more rows, and 9 more variables: lat <dbl>, lon <dbl>,
#> #   room_type <chr>, price <dbl>, min_nights <dbl>, reviews <dbl>,
#> #   last_review_date <date>, reviews_per_month <dbl>, available_days <dbl>
```

Shiny app: <https://qiushiyan.shinyapps.io/nyclodging/>

Package documentation: <https://qiushiyan.github.io/nyclodging>

## Installation

You can install the development version of nyclodging like so:

``` r
remotes::install_github("qiushiyan/nyclodging")
```

## Usage

To start the shiny app locally

``` r
library(nyclodging)
run_app()
```

Or if you prefer using docker

    docker pull qiushiyan/nyclodging
    docker run -p 8080:80 --rm qiushiyan/nyclodging

and then navigate to <http://localhost:8080/>

## Source

-   Inside Airbnb public data <http://insideairbnb.com/>

-   Kaggle Dataset
    <https://www.kaggle.com/dgomonov/new-york-city-airbnb-open-data>
