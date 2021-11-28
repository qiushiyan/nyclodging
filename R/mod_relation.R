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
  
  
  select_ui <- col_3(
    selectInput(ns("x"), "x", names_that_are("numeric")), 
    selectInput(ns("y"), "y", names_that_are("numeric"))
  )
  
  plot_ui <- col_9(
    col_12(
      actionButton(
        ns("render"), 
        "Render Plot", icon = icon("arrow-down")
      ) %>%
        tags$div(align = "center", style = "padding-left:2em"),
      shinycssloaders::withSpinner(
        plotOutput(ns("plot")) %>% 
          tagAppendAttributes(
            onclick = sprintf("setInputValue('%s', true)", ns("show"))
          )
      )
    ),
    HTML("&nbsp;"),
    col_12(
      tags$p(
        "Click on the graph to see the code"
      ) %>%
        tags$div(align = "center")
    ), 
    col_12(
      downloadButton(ns("dl")) %>%
        tags$div(align = "right")
    )
  )
  
  
  tagList(
    select_ui, 
    plot_ui 
  )
}
    
#' relation Server Functions
#'
#' @noRd 
mod_relation_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    observeEvent( input$x , {
      
    })
    
    
    output$plot <- renderPlot(
      plot(cars)
    )
    
  })
}
    
## To be copied in the UI
# mod_relation_ui("relation_ui_1")
    
## To be copied in the server
# mod_relation_server("relation_ui_1")
