#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic 
  
  font_size <- get_golem_config("base_font_size")
  
  mod_dataset_server("about")
  mod_spatial_server("spatial")
  mod_text_server("text")
  mod_dist_server("dist", font_size)
  mod_relation_server("relation", font_size)
  mod_gallery_server("gallery")
}
