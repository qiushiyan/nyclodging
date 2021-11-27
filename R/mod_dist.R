#' ui function for exploring single-variable distribution 
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
mod_dist_ui <- function(id) {
  ns <- NS(id)
  
  themes <- c("theme_bw", 
              "theme_classic", 
              "theme_dark",
              "theme_gry", 
              "theme_light",
              "theme_linedraw",
              "theme_minimal", 
              "theme_void")
  
  palettes <- colourvalues::colour_palettes()


  dist_ui <- col_3(
    h4("Visualize single-variable distribution"),
    selectInput(ns("x"), "variable", 
                choices = plot_vars, 
                selected = "price"), 
    selectInput(ns("dist_type"), 
                "plot type", 
                choices = NULL,
                selected = NULL),
    selectInput(ns("dist_fill"),
                "fill",
                choices = NULL,
                selected = NULL),
    selectInput(ns("dist_scale"),
                "scale",
                choices = c("original", "log10"),
                selected = "original"),
    selectInput(
      ns("theme"),
      "theme", 
      choices = themes
    ), 
    selectInput(
      ns("palette"),
      "palette", 
      choices = palettes,
      selected = "viridis"
    ), 
    textInput(
      ns("title"),
      "plot title",
      value = ""
    )
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
      
    )
  )

  
  tagList(
    dist_ui, 
    plot_ui
  )

  
}
    
#' mod_dist Server Functions
#'
#' @noRd 
mod_dist_server <- function(id) { 
  moduleServer( id, function(input, output, session) {
    
    ns <- session$ns
    
    r <- rv(
      plot = ggplot(listings), 
      code = "ggplot(listings)"
    )
    
    
    # change available plot type 
    observeEvent( input$x , {
      if (is.numeric(listings[[input$x]])) {
        updateSelectInput(session, 
                          "dist_type", 
                          choices = c("histogram", "density", "boxplot"),
                          selected = "histogram")
        # use log 10 scales 
        
      } else  {
        updateSelectInput(session, 
                          "dist_type",
                          choices = "bar", 
                          selected = "bar", 
        )
      }
    })
    
    
    # show modal for plot code 
    observeEvent( input$show , {
      showModal(modal(r$code))
    })
    
    # render plot action 
    observeEvent( input$render , {
        scale <- switch(input$dist_scale,
                        "original" = list(
                          fun = scale_x_continuous(),
                          code = "scale_x_continuous()"
                          ),
                        "log10" = list(
                          fun = scale_x_log10(), 
                          code = "scale_x_log10()"
                         )
        )
        
        
        if (input$dist_type == "histogram") {
          if (is.null(input$dist_fill)) {
            r$plot <- ggplot(listings, aes(.data[[input$x]])) +
              geom_histogram() + 
              scale$fun 
            
            r$code <- sprintf(
              "ggplot(listings, aes(%s)) + 
                geom_histogram() + 
                %s
            ", 
            input$x,
            scale$code
          )
        }
      }
      
      r$plot <- r$plot +  
        get(input$theme)()
      
      r$code <- sprintf(
        '%s + %s()', 
        r$code, input$theme
      )
      
      if (input$title != ""){
        r$plot <- r$plot + 
          labs(title = input$title)
        r$code <- sprintf(
          '%s +\n  labs(title = "%s")', 
          r$code, input$title
        )
      }
    }
  )
    
    
    output$plot <- renderPlot({
      r$plot
    })
    
    
  })
}
    
