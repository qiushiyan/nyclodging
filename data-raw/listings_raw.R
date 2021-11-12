# read raw listing data

library(pins)
library(dplyr)
library(purrr)

read_from_kaggle <- function(name = "dgomonov/new-york-city-airbnb-open-data") {
  board <- board_kaggle_dataset(username = "enixam", 
                                key = Sys.getenv("KAGGLE_TOKEN"))
  
  csv_path <- board %>% 
    pin_download(name = "dgomonov/new-york-city-airbnb-open-data") %>% 
    grep("\\.csv", ., value = TRUE)
  
  listings_raw <- readr::read_csv(csv_path)
} %>% safely()


read_from_kaggle <- safely(read_from_kaggle)

out <- read_from_kaggle()

if (is.null(out$result)) {
  # when there is a reading error 
  listings_raw <- readr::read_csv("data-raw/AB_NYC_2019.csv")
} else {
  listings_raw <- out$result
}

usethis::use_data(listings_raw, internal = TRUE, overwrite = TRUE)
