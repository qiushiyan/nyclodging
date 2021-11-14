#' utility functions for mod_viz
#'
#' @description switch ui for distribution, relationship, spatial and text 
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd

switch_ui <- function(type, ns) {
  switch(type, 
         "dist" = dist_ui(ns),
         "relation" = relation_ui(ns),
         "spatial" = spatial_ui(ns),
         "text" = text_ui(ns))
}


#' ui for visualizing distribution
#' @import shiny 
#' @importFrom glue glue
dist_ui <- function(ns) {
  tagList(
    col_3(
      h4(glue("Visualize single-variable distribution")),
      selectInput(ns("type"), "plot type", 
                  choices = c("histogram", "density", "boxplot"))
    ), 
    col_9(
      col_12(
        plotOutput(ns("dist-plot")) %>% 
          tagAppendAttributes(
            onclick = glue("setInputValue({'ns(\'show\')'}, true)")
          ), 
        actionButton(
          ns("render"), 
          "Render Plot", icon = icon("arrow-down")
        ) %>%
          tags$div(align = "center", style = "padding-left:2em")
      ), 
    )    
  )
} 

relation_ui <- function(ns) {
  tagList(
    h4("ui for rleation")
  )
} 

spatial_ui <- function(ns) {
  tagList(
    h4("ui for spatial")
  )
} 

text_ui <- function(ns) {
  tagList(
    h4("ui for text")
  )
} 
