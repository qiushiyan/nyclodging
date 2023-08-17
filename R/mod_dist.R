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
#' @importFrom dplyr pull slice_sample
#' @importFrom colourvalues color_values
#' @importFrom shinycssloaders withSpinner
#' @import ggplot2
mod_dist_ui <- function(id) {
  ns <- NS(id)

  themes <- c(
    "theme_bw",
    "theme_classic",
    "theme_dark",
    "theme_gry",
    "theme_light",
    "theme_linedraw",
    "theme_minimal",
    "theme_void"
  )

  palettes <- colourvalues::colour_palettes()


  select_ui <- col_3(
    col_12(h4("Visualize single-variable distribution")),
    selectInput(ns("x"),
      "variable",
      choices = c("", plot_vars),
      selected = NULL
    ),
    selectInput(ns("type"),
      "plot type",
      choices = "",
      selected = NULL
    ),
    selectInput(ns("fill"),
      "fill variable",
      choices = "",
      selected = NULL
    ),
    selectInput(ns("scale"),
      "scale for x axis",
      choices = c("original", "log10"),
      selected = "log10"
    ),
    selectInput(
      ns("theme"),
      "theme",
      choices = themes,
    ),
    selectInput(
      ns("palette"),
      "palette",
      choices = palettes,
      selected = "pubu"
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
        "Render Plot",
        icon = icon("arrow-down")
      ) %>%
        tags$div(align = "center", style = "padding-left:2em"),
      withSpinner(
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
mod_dist_server <- function(id, font_size = 16) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    r <- rv(
      plot = ggplot(listings %>% slice_sample(n = 5000)) +
        geom_histogram(aes(price, fill = room_type), position = "identity", alpha = 0.4) +
        scale_fill_viridis_d() +
        scale_x_log10() +
        labs(title = "Distribution of price group by room type") +
        theme_bw(base_size = 16),
      code = "ggplot(listings)"
    )


    # change available plot type
    observeEvent(input$x, {
      if (is.numeric(listings[[input$x]]) || input$x == "") {
        updateSelectInput(session,
          "type",
          choices = c("histogram", "density", "boxplot"),
          selected = "histogram"
        )

        updateSelectInput(session,
          "scale",
          choices = c("original", "log10"),
          selected = "log10"
        )
      } else {
        # only support bar plot and original axis for character variables
        updateSelectInput(session,
          "type",
          choices = "bar",
          selected = "bar",
        )

        updateSelectInput(session,
          "scale",
          choices = "original",
          selected = "original"
        )
      }

      # update fill input so that it's not the same as x
      updateSelectInput(session,
        "fill",
        choices = c("", setdiff(group_vars, input$x)),
        selected = NULL
      )
    })


    # show modal for plot code
    observeEvent(input$show, {
      showModal(modal(r$code))
    })

    # render plot action
    observeEvent(input$render, {
      if (input$x == "") {
        showFeedbackWarning(
          inputId = "x",
          text = "please select a variable"
        )
      } else {
        if (is.numeric(listings[[input$x]])) {
          xscale <- switch(input$scale,
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
          "bar" = "geom_bar"
        )

        # ungrouped plot
        if (input$fill == "") {
          r$plot <- ggplot(listings, aes(.data[[input$x]])) +
            get(type)()

          r$code <- sprintf(
            "ggplot(listings, aes(%s)) +
                %s()",
            input$x,
            type
          )
        }
        # grouped plot
        else {
          base_plot <- ggplot(listings, aes(.data[[input$x]],
            fill = .data[[input$fill]]
          )) +
            scale_fill_manual(
              values = color_values(
                1:length(unique(dplyr::pull(listings, .data[[input$fill]]))),
                palette = input$palette
              )
            )

          # position = "dodge" for bar plot
          if (type == "geom_bar") {
            r$code <- sprintf(
              "ggplot(listings, aes(%s, fill = %s)) +
              %s(position = 'dodge') +
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
            r$plot <- base_plot +
              get(type)(position = "dodge")
          }

          # no position adjustment for box plot
          else if (type == "geom_boxplot") {
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
            r$plot <- base_plot +
              get(type)()
          }

          # position = "identity" for other plots
          else {
            r$code <- sprintf(
              "ggplot(listings, aes(%s, fill = %s)) +
                %s(position = 'identity', alpha = 0.4) +
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
            r$plot <- base_plot +
              get(type)(position = "identity", alpha = 0.4)
          }
        }

        r$plot <- r$plot +
          get(xscale)() +
          labs(title = input$title) +
          get(input$theme)(base_size = font_size)


        r$code <- sprintf(
          "%s +
            %s() +
            labs(title = '%s') +
            %s(base_size = %s)",
          r$code, xscale, input$title, input$theme, font_size
        )
      }
    })


    output$plot <- renderPlot({
      r$plot
    })

    output$dl <- downloadHandler(
      filename = function() {
        paste("nyclodging", input$x, "distribution.png", sep = "-")
      },
      content = function(con) {
        ggsave(con, r$plot, device = "png", width = 16, height = 8)
      }
    )
  })
}
