library(echarts4r)
library(dplyr)
library(sf)
library(ggplot2)
library(tmap)
library(leaflet)


ggplot(listings) + 
  geom_sf()

library(nycgeo)

nyc <- nyc_boundaries(geography = "tract") %>% 
  st_set_crs(3857)

listings <- st_as_sf(nyclodging::listings, coords = c("lon", "lat")) %>%
  st_set_crs(3857)

tmap_mode("plot")
df <- nyc %>% 
  st_join(listings)

df %>% 
  tmap::tm_shape() +
  tmap::tm_polygons(
    col = "neighbourhood", 
    interactive = TRUE, 
    title = "Number of reported\nbike accidents",
    palette = rev(rcartocolor::carto_pal(n = 5, "ag_Sunset")),
    breaks = c(1, 5, 10, 15, 20, 25, 30, Inf),
    alpha = .75, border.col = "white",
    legend.reverse = TRUE,
    textNA = "No Accidents in 2019",
    popup.vars = c("District:" = "neighbourhood")
  ) + 
  tm_dots(
    col = "price"
  )


tm_polygons() + 
  tm_fill(col = "puma_id")
