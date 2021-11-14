#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic 
  
  mod_dataset_server("dataset_about")
  
  mod_viz_server("viz_distribution", "dist")
  mod_viz_server("viz_relationship", "relation")
  mod_viz_server("viz_spatial", "spatial")
  mod_viz_server("viz_text", "text")
  
  mod_gallery_server("gallery")
}
