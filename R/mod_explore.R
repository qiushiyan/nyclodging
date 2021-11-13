#' explore UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @importFrom magrittr %>%
#' @import ggplot2
mod_explore_ui <- function(id){
  ns <- NS(id)
  tagList(
    nav_(
      "Explore Airbnb listings in NYC",
      c(
        "dataset" = "Dataset",
        "distribution" = "Distribution",
        "relationship" = "Relationship",
        "spatial" = "Spatial Analysis",
        "text" = "Text Analysis"
      )
    ), 
    tags$div(
      class = "container", 
      fluidRow(
        id = "dataset", 
        mod_explore_dataset_ui("explore_dataset")
      ) %>% tagAppendAttributes(style = "display: none;"),
      fluidRow(
        id = "distribution", 
        mod_explore_viz_ui("explore_viz_distribution")
      ) %>% tagAppendAttributes(style = "display: none;"),
      fluidRow(
        id = "relationship", 
        mod_explore_viz_ui("explore_viz_relationship")
      ) %>% tagAppendAttributes(style = "display: none;"),
      fluidRow(
        id = "spatial", 
        mod_explore_viz_ui("explore_viz_spatial")
      ) %>% tagAppendAttributes(style = "display: none;"),
      fluidRow(
        id = "text", 
        mod_explore_viz_ui("explore_viz_text")
      ) %>% tagAppendAttributes(style = "display: none;")
    )
  )
}
    
#' explore Server Functions
#'
#' @noRd 
mod_explore_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    r <- rv(
      plot = ggplot(listings), 
      code = "ggplot(listings)"
    )
    
    output$plot <- renderPlot({
      plot(cars)
    })
    
    observeEvent(input$show, {
      showModal(modal(r$code))
    })
    

    

 
  })
}
    
## To be copied in the UI
# mod_explore_ui("explore_ui_1")
    
## To be copied in the server
# mod_explore_server("explore_ui_1")

