#' explore_viz UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList fluidRow
mod_explore_viz_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h1(sprintf("this is explore_%s", id)),
    fluidRow(
      sliderInput(ns("slider"), label = "select a number", 0, 10, 5), 
      plotOutput(ns("hist")) %>% tagAppendAttributes(
        onclick = sprintf("setInputValue('%s', true)", ns("show"))
      )
    )
  )
}
    
#' explore_viz Server Functions
#'
#' @noRd 
mod_explore_viz_server <- function(id){
  moduleServer( id, function(input, output, session) {
    
    ns <- session$ns
    
    observeEvent( input$show , {
      print("triggering")
      val <- isolate(input$show)
      print(val)
      showModal(modal("hello world"))
    })
    
    
    
    output$hist <- renderPlot({
      hist(cars$speed)
    })
  })
}
    
## To be copied in the UI
# mod_explore_viz_ui("explore_viz_ui_1")
    
## To be copied in the server
# mod_explore_viz_server("explore_viz_ui_1")
