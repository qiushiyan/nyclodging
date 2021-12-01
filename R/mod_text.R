#' text UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @import leaflet 
mod_text_ui <- function(id){
  ns <- NS(id)
  
  select_ui <- col_6(
    
  )
  
  tagList(
    h1("text"),
    leafletOutput(ns("plot"))
  )
}
    
#' text Server Functions
#'
#' @noRd 
mod_text_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$plot <- renderLeaflet(
      leaflet() %>% 
        setView(lng = -71.0589, lat = 42.3601, zoom = 12) %>% 
        addTiles()
    )
    
    observeEvent(input$plot_click, {
      print(input$plot_click)
    })
  })
}
    
## To be copied in the UI
# mod_text_ui("text_ui_1")
    
## To be copied in the server
# mod_text_server("text_ui_1")
