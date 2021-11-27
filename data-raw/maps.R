library(nycgeo)
library(dplyr)
nyc_boundaries(geography = "nta")

library(tmap)
library(sf)

df <- listings %>% 
  st_as_sf(coords = c("lon", "lat")) %>% 
  st_set_crs(3857) %>% 
  st_join(
    nyc_boundaries(geography = "nta") %>% 
      st_set_crs(3857),
  )


# tm_shape(df) + 
#   tm_dots(col = "price") + 
tm_shape(nyc_boundaries(geography = "nta") %>% st_set_crs(3857)) + 
  tm_polygons() + 
  tm_shape(df) + 
  tm_dots(col = "price")


nyc_boundaries(geography = "tract")

listings %>% 
  e_charts(lon) %>% 
  e_geo(
    roam = TRUE,
    
  ) %>%
  e_scatter(
    lat, lon,
    coord_system = "geo"
  ) %>%
  e_visual_map()
