#' mod_text 
#'
#' @description predict price range classification 
#'
#' @return The return value, if any, from executing the function.
#'
#' @import sf
#' @importFrom nycgeo nyc_boundaries
#' @importFrom readr read_rds
#' @import workflows
#' @import recipes
#' @import textrecipes
#' @importFrom broom augment 
#' @importFrom shinyFeedback showFeedbackWarning
#' @noRd
predice_price <- function(classification_model, lon, lat, neighbourhood, description) {
  df_to_predict <- tibble(
    list_description = description, 
    lon = lon, 
    lat = lat, 
    neighbourhood_group = neighbourhood
  )
  print(df_to_predict)
  
  # predict
  df_predicted <- augment(classification_model, df_to_predict) %>% 
    select(last_col(0:6)) %>% 
    tidyr::pivot_longer(everything(), names_to = "class", values_to = "prob") %>% 
    mutate(class = gsub("\\.pred_", "", class),
           class = factor(class, levels = rev(c("< 100", "100 to 200", "200 to 300", "300 to 400", "400 to 500", "500 to 1000", "> 1000"))))
  
  df_predicted
}

#'
#' @description get parent nyc neighbourhood based on user input 
#' @noRd
get_neighbourhood <- function(nyc_borough, lon, lat) {
  selected <- data.frame(
    lon = lon, 
    lat = lat
  ) %>% 
    st_as_sf(coords = c(lon = "lon", lat = "lat")) %>% 
    st_set_crs(4326)
  
  neighbourhood <- selected %>% 
    st_join(nyc_borough) %>% 
    .[["borough_name"]]
  
  neighbourhood
}