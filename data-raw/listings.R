# clean listing data

library(dplyr)
library(stringr)
library(lubridate)
library(ggplot2)
library(tidyr)

listings_raw %>% glimpse()

# check character columns 
# some rows contain extra space
# could remove some symbols (e.g., &, -, \n)
listings_raw %>% 
  select(where(is.character)) %>% 
  filter(if_any(everything(), ~ str_detect(.x, "[^[:print:]]")))

# room_type could be normalized 
listings_raw %>% count(room_type, sort = TRUE)

# calculated_host_listings_count is at per-host level
listings_raw %>%
  filter(host_id == 2787) %>% 
  select(id, name, calculated_host_listings_count)

# distribution of numerical variables
listings_raw %>% 
  select(where(is.numeric), -longitude, -latitude, -id, -host_id, -calculated_host_listings_count) %>% 
  pivot_longer(everything()) %>% 
  ggplot() + 
  geom_histogram(aes(value)) + 
  facet_wrap(~ name, scales = "free") + 
  scale_x_log10()

# final clean 
listings <- listings_raw %>% 
  mutate(across(where(is.character), str_squish)) %>% 
  transmute(
    list_id = id, 
    list_description = name, 
    host_id, 
    host_name,
    neighbourhood_group, 
    neighbourhood, 
    lat = latitude,
    lon = longitude, 
    room_type = case_when(
      room_type == "Entire home/apt" ~ "entire room", 
      TRUE ~ str_to_lower(room_type)
    ), 
    price, 
    min_nights = minimum_nights, 
    reviews = number_of_reviews, 
    last_review_date = ymd(last_review),
    reviews_per_month, 
    available_days = availability_365
  )

usethis::use_data(listings)
readr::write_csv(nyclodging::listings, here::here("inst", "extdata", "listings.csv"))

# internal data 
# available plotting variables 
plot_vars <- colnames(listings[, -(1:4)])

# available group variables 
group_vars <- c("neighbourhood_group", 
                "neighbourhood", 
                "room_type", 
                "price", 
                "min_nights", 
                "reviews", 
                "reviews_per_month",
                "available_days")

# categorize numerical variables for graph gallery 
listings_cut <- listings %>% 
  mutate(
    price_cut = cut(price, c(0, 100, 200, 300, 400, 500, Inf)),
    min_nights_cut = case_when(
      min_nights == 1 ~ "1 day",
      min_nights <= 3 ~ "2 to 3 days",
      min_nights <= 7 ~ "4 to 7 days", 
      min_nights >= 7 ~ "less than 7 days"
    ), 
    reviews_cut = cut(reviews, c(0, 20, 50, 100, Inf)), 
    available_days_cut = case_when(
      available_days <= 7 ~ "less than a week", 
      available_days <= 30 ~ "less than a month", 
      available_days <= 90 ~ "less than 3 months", 
      available_days <= 180 ~ "less than half year", 
      available_days <= 360 ~ "more than half year", 
      available_days > 360 ~ "all available"
    )
  )

usethis::use_data(listings_raw, listings_cut, plot_vars, group_vars, internal = TRUE, overwrite = TRUE)
