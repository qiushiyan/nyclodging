#' explore_viz UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList fluidRow
#' @importFrom glue glue
#' @import ggplot2
mod_viz_ui <- function(id, type) {
  ns <- NS(id)
  

  dist_ui <- col_3(
    h4("Visualize single-variable distribution"),
    selectInput(ns("x"), "variable", 
                choices = plot_vars, 
                selected = "price"), 
    selectInput(ns("dist_type"), 
                "plot type", 
                choices = NULL),
    selectInput(ns("group"),
                "group",
                choices = group_vars),
    selectInput(ns("scale"),
                "scale",
                choices = c("original", "log10"))
  )
  
  plot_ui <- col_9(
    col_12(
      actionButton(
        ns("render"), 
        "Render Plot", icon = icon("arrow-down")
      ) %>%
        tags$div(align = "center", style = "padding-left:2em"),
      plotOutput(ns("plot")) %>% 
        tagAppendAttributes(
          onclick = sprintf("setInputValue('%s', true)", ns("show"))
        )
    )
  )
  
  if (type == "dist") {
    tagList(
      dist_ui, 
      plot_ui
    )
  }
  
  else if (type == "relation") {
    h1(type)
  }
  
  else if (type == "spatial") {
    h1(type)
  }
  
  else if (type == "text") {
    h1(type)
  }
  
}
    
#' explore_viz Server Functions
#'
#' @noRd 
mod_viz_server <- function(id, type) { 
  moduleServer( id, function(input, output, session) {
    
    ns <- session$ns
    
    r <- rv(
      plot = ggplot(listings), 
      code = "ggplot(listings)"
    )
    
    
    # change available plot type 
    observeEvent( input$x , {
      if (type == "dist") {
        if (is.numeric(listings[[input$x]])) {
          updateSelectInput(session, 
                            "dist_type", 
                            choices = c("histogram", "density", "boxplot"),
                            selected = "histogram")
        } else  {
          updateSelectInput(session, 
                            "dist_type",
                            choices = "bar", 
                            selected = "bar", 
          )
        }
      }

      
    })
    
    
    # show modal for plot code 
    observeEvent( input$show , {
      showModal(modal(r$code))
    })
    
    # render plot action 
    
    observeEvent( input$render , {

      if (type == "dist") {
        if (input$dist_type == "histogram") {
          r$plot <- ggplot(listings, aes(.data[[input$x]])) +
            geom_histogram()
    
          r$code <- sprintf(
            "ggplot(listings, aes(%s)) + 
                geom_histogram()
            ", 
            input$x
          )
        }

      }
      

      
    })
    
    
    
    output$plot <- renderPlot({
      r$plot
    })
  })
}
    
