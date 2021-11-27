#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic 
  
  mod_dataset_server("about")
  mod_dist_server("dist")
  mod_relation_server("relation")
  mod_spatial_server("spatial")
  mod_text_server("text")
  mod_gallery_server("gallery")
}
