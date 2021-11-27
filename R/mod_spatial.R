#' spatial UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_spatial_ui <- function(id){
  ns <- NS(id)
  tagList(
    h1("spatial")
  )
}
    
#' spatial Server Functions
#'
#' @noRd 
mod_spatial_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_spatial_ui("spatial_ui_1")
    
## To be copied in the server
# mod_spatial_server("spatial_ui_1")
