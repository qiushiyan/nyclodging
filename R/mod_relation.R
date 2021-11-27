#' relation UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_relation_ui <- function(id){
  ns <- NS(id)
  tagList(
    h1("relationship")
  )
}
    
#' relation Server Functions
#'
#' @noRd 
mod_relation_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_relation_ui("relation_ui_1")
    
## To be copied in the server
# mod_relation_server("relation_ui_1")