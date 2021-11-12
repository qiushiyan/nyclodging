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
