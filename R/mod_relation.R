#' relation UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @importFrom shinycssloaders withSpinner
#' @importFrom ggstatsplot ggscatterstats grouped_ggscatterstats
mod_relation_ui <- function(id) {
  ns <- NS(id)
  
  themes <- c("theme_bw", 
              "theme_classic", 
              "theme_dark",
              "theme_gry", 
              "theme_light",
              "theme_linedraw",
              "theme_minimal", 
              "theme_void")

  select_ui <- col_3(
    col_12(
      h4("Visualize bivariate relationship")
    ), 
    selectInput(ns("x"), "x", c("", names_that_are("numeric")), selected = NULL), 
    selectInput(ns("y"), "y", c("", names_that_are("numeric")), selected = NULL),
    selectInput(ns("xscale"), "scale for x axis", c("original", "log10"), selected = "log10"),
    selectInput(ns("yscale"), "scale for y axis", c("original", "log10"), selected = "log10"), 
    selectInput(ns("group"), "group by", c("", "room_type", "neighbourhood_group"), selected = NULL),
    selectInput(ns("theme"), "theme", themes), 
    textInput(ns("title"), "title", "")
  )
  
  plot_ui <- col_9(
    col_12(
      actionButton(
        ns("render"), 
        "Render Plot", icon = icon("arrow-down")
      ) %>%
        tags$div(align = "center", style = "padding-left:2em"),
      withSpinner(
        plotOutput(ns("plot"), height = "750px") %>% 
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
mod_relation_server <- function(id, font_size = 16) {
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    vars <- names_that_are("numeric")
    
    r <- rv(
      plot = ggstatsplot::grouped_ggscatterstats(
        listings,
        x = price,
        y = reviews,
        grouping.var = room_type,
        ggplot.component = list(
          scale_x_log10(),
          scale_y_log10()
        ),
        ggtheme = theme_bw(base_size = 16),
        annotation.args = list(title = 'price vs. reviews'),
        plotgrid.args = list(ncol = 1)
      ), 
      code = "ggplot(listings)"
    )
    
    
    observeEvent( input$x , {
      if (input$x != "") {
        updateSelectInput(session, 
                          "y", 
                          choices = c("", setdiff(vars, input$x)), 
                          selected = isolate(input$y))
      }
      if (input$group != "") {
        updateSelectInput(session, 
                          "group", 
                          choices = c("", "room_type", "neighbourhood_group"), 
                          selected = NULL)
      }
    })
    
    observeEvent( input$y , {
      if (input$y != "") {
        updateSelectInput(session,
                          "x", 
                          choices = c("", setdiff(vars, input$y)), 
                          selected = isolate(input$x))
      }
      if (input$group != "") {
        updateSelectInput(session, 
                          "group", 
                          choices = c("", "room_type", "neighbourhood_group"), 
                          selected = NULL)
      }
    })
    
    # show modal for plot code 
    observeEvent( input$show , {
      showModal(modal(r$code))
    })
    
    
    observeEvent( input$render , {
      xscale <- switch(
        input$xscale,
        "original" = "scale_x_continuous", 
        "log10" = "scale_x_log10"
      )
      yscale <- switch(
        input$yscale, 
        "original" = "scale_x_continous",
        "log10" = "scale_x_log10"
      )
      
      if (input$group != "") {
        r$plot <- grouped_ggscatterstats(
          listings, 
          x = !!input$x, 
          y = !!input$y, 
          grouping.var = !!input$group, 
          ggplot.component = list(
            get(xscale)(), 
            get(yscale)()
          ), 
          ggtheme = get(input$theme)(base_size = font_size), 
          annotation.args = list(title = input$title),
          plotgrid.args = list(ncol = 1)
        ) 
        
        r$code <- sprintf("
          ggstatsplot::grouped_ggscatterstats(
            listings,
            x = %s,
            y = %s,
            grouping.var = %s,
            ggplot.component = list(
              %s(,
              %s()
            ),
            ggtheme = %s(base_size = %s),
            annotation.args = list(title = '%s'),
            plotgrid.args = list(ncol = 1)
          )", input$x, input$y, input$group, xscale, yscale, input$theme, font_size, input$title
        )
        print("code for group")
      } else {
        r$plot <- ggscatterstats(
          listings, 
          x = !!input$x, 
          y = !!input$y, 
          ggplot.component = list(
            get(xscale)(), 
            get(yscale)()
          ), 
          ggtheme = get(input$theme)(base_size = font_size), 
          annotation.args = list(title = input$title),
        )

        r$code <- sprintf("
          ggstatsplot::ggscatterstats(
            listings,
            x = %s,
            y = %s,
            ggplot.component = list(
              %s(),
              %s()
            ),
            ggtheme = %s(base_size = %s),
            annotation.args = list(title = '%s')
          )", input$x, input$y, xscale, yscale, input$theme, font_size, input$title)
        print("code for non-group")
        
      }
     })
    
    
    
    output$plot <- renderPlot({
      r$plot
    })
    
    
    output$dl <- downloadHandler(
      filename = function() {
        paste('nyclodging', input$x, input$y, 'relationship.png', sep = "-")
      },
      content = function(con) {
        ggsave(con, r$plot, device = "png", width = 14, height = 16)
      }
    )
    
  })
}
    
## To be copied in the UI
# mod_relation_ui("relation_ui_1")
    
## To be copied in the server
# mod_relation_server("relation_ui_1")
