map_df <- nyc_boundaries(geography = "tract") %>% 
  st_transform(4326) %>% 
  st_join(listings %>% 
            st_as_sf(coords = c(lon = "lon", lat = "lat")) %>% 
            st_set_crs(4326)
  ) %>% 
  rename(neighbourhood_name = borough_name) %>% 
  group_by(tract_id, neighbourhood_name) %>% 
  summarise(
    median_price = median(price, na.rm = TRUE),
    max_price = median(price, na.rm = TRUE), 
    min_price = min(price, na.rm = TRUE),
    houses = n()
  ) %>% 
  ungroup()

usethis::use_data(map_df, overwrite = TRUE)
