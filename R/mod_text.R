#' text UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_text_ui <- function(id){
  ns <- NS(id)
  tagList(
    h1("text")
  )
}
    
#' text Server Functions
#'
#' @noRd 
mod_text_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_text_ui("text_ui_1")
    
## To be copied in the server
# mod_text_server("text_ui_1")
