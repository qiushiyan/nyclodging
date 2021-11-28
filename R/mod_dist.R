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
#' @importFrom dplyr pull 
#' @importFrom colourvalues color_values
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
  
  
  select_ui <- col_3(
    h4("Visualize single-variable distribution"),
    selectInput(ns("x"), 
                "variable", 
                choices = c("", plot_vars), 
                selected = NULL), 
    selectInput(ns("type"), 
                "plot type", 
                choices = "",
                selected = NULL),
    selectInput(ns("fill"),
                "fill variable",
                choices = "",
                selected = NULL),
    selectInput(ns("scale"),
                "scale for x axis",
                choices = c("original", "log10"), 
                selected = "log10"),
    selectInput(
      ns("theme"),
      "theme", 
      choices = themes,
      selected = "pubu"
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
                          "type", 
                          choices = c("histogram", "density", "boxplot"),
                          selected = "histogram")
        
        updateSelectInput(session, 
                          "scale", 
                          choices = c("original", "log10"), 
                          selected =  "log10")
        
      } else  {
        # only support bar plot and original axis for character variables 
        updateSelectInput(session, 
                          "type",
                          choices = "bar", 
                          selected = "bar", 
        )
        
        updateSelectInput(session, 
                          "scale", 
                          choices = "original", 
                          selected = "original")
        
      }
      
      # update fill input so that it's not the same as x 
      updateSelectInput(session, 
                        "fill", 
                        choices = c("", setdiff(group_vars, input$x)),
                        selected = NULL)
    })
    
    
    # show modal for plot code 
    observeEvent( input$show , {
      showModal(modal(r$code))
    })
    
    # render plot action 
    observeEvent( input$render, {
      if (is.numeric(listings[[input$x]])) {
        xscale <- switch(
          input$scale,
          "original" = "scale_x_continuous", 
          "log10" = "scale_x_log10"
        )
      } else {
        xscale <- "scale_x_discrete"
      }
      
      type <- switch(input$type, 
                     "histogram" = "geom_histogram", 
                     "density" = "geom_density", 
                     "boxplot" = "geom_boxplot",
                     "bar" = "geom_bar")
      
      
      if (input$fill == "") {
        r$plot <- ggplot(listings, aes(.data[[input$x]])) +
          get(type)()
        
        r$code <- sprintf(
          "ggplot(listings, aes(%s)) + 
                %s()
            ", 
          input$x,
          type 
        )
      } 
      else {
        r$plot <- ggplot(listings, aes(.data[[input$x]], 
                                       fill = .data[[input$fill]])) +
          get(type)() + 
          scale_fill_manual(
            values = color_values(
              1:length(unique(dplyr::pull(listings, .data[[input$fill]]))), 
              palette = input$palette
            ))
        
        r$code <- sprintf(
          "ggplot(listings, aes(%s, fill = %s)) + 
              %s() +
              scale_color_manual(
                values = color_values(
                  1:length(unique(dplyr::pull(listings, %s))),
                  palette = '%s' 
                )
              )", 
          input$x, 
          input$fill,  
          type, 
          input$fill, 
          input$palette 
        )
      }
      
      
      r$plot <- r$plot +
        get(input$theme)() +
        get(xscale)()
      
      r$code <- sprintf(
        '%s + %s() + %s()',
        r$code, input$theme, xscale
      )
      
      if (input$title != "") {
        r$plot <- r$plot +
          labs(title = input$title)
        r$code <- sprintf(
          '%s +\n  labs(title = "%s")',
          r$code, input$title
        )
      }
    })
    
    
    output$plot <- renderPlot({
      r$plot
    })
    
    output$dl <- downloadHandler(
      filename = function() {
        paste0('nyclodging-', input$dist_x, '-distribution.png')
      },
      content = function(con) {
        ggsave(con, r$plot, device = "png", width = 16, height = 8)
      }
    )
    
    
  })
}
