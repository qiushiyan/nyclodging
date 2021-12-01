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
  
  select_ui <- col_8(
    col_12(textInput(ns("description"), 
                     "description of the house", 
                     placeholder = "2b2b with awesome harbour view", 
                     width = "100%")), 
    tags$div(
        col_6(
          sliderInput(ns("lon"), "longitude", min = -74.2, max = -73.7, value = -73.9), 
        ), 
        col_6(
          sliderInput(ns("lat"), "latitude", min = 40.5, max = 40.9, value = 40.7)
        )
    ) %>% tagAppendAttributes(style = "display:flex;pad"), 
    col_12(
      p("click on the map the pick a location"), 
      leafletOutput(ns("plot"))
    )
  )
  
  predict_ui <- col_4(
    verbatimTextOutput(ns("result"))
  )
  
  tagList(
    select_ui, 
    predict_ui 
  )
}
    
#' text Server Functions
#'
#' @noRd 
mod_text_server <- function(id) {
  moduleServer( id, function(input, output, session) {
    ns <- session$ns
    
    house_icon <- makeIcon(
      iconUrl = app_sys("app/www/house_icon.png")
    )
  
    observeEvent(input$plot_click, {
      updateSliderInput(session, "lon", value = isolate(input$plot_click$lng))
      updateSliderInput(session, "lat", value = isolate(input$plot_click$lat))
    })
    
    output$plot <- renderLeaflet({
        leaflet() %>% 
          addTiles() %>% 
          addMarkers(lng = input$lon, 
                     lat = input$lat,
                     popup = "my awesome house",
                     icon = house_icon)
    
        })
    
  })
}
    
## To be copied in the UI
# mod_text_ui("text_ui_1")
    
## To be copied in the server
# mod_text_server("text_ui_1")
