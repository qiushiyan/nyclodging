#' spatial UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @importFrom shinycssloaders withSpinner
#' @import tmap 
#' @import sf 
#' @import nycgeo
mod_spatial_ui <- function(id){
  ns <- NS(id)
  tagList(
    col_12(
      h5("Geographical pricing ranges"), 
      p("The map fill shows the spatial distribution of listing's median price across NYC down to tract level, click on indivisual blocks to learn more"), 
      withSpinner(
        tmapOutput(ns("plot"), height = "70vh")
      )
    )
  )
}
    
#' spatial Server Functions
#'
#' @noRd 
mod_spatial_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$plot <- renderTmap({
      tm_shape(map_df) + 
        tm_polygons(col = "median_price", 
                    palette = rev(rcartocolor::carto_pal(n = 7, "ag_Sunset")),
                    breaks = c(0, 100, 200, 300, 500, 1000, Inf),
                    popup.vars = c(
                      "Median price" = "median_price", 
                      "Borough" = "neighbourhood_name",
                      "Houses" = "houses", 
                      "Max price" = "max_price", 
                      "Min price" = "min_price"
                    )) + 
        tm_view(set.view = c(-73.8, 40.7, 10)) + 
        tm_basemap(providers$Stamen.Toner)
      
    })
  })
}
    
## To be copied in the UI
# mod_spatial_ui("spatial_ui_1")
    
## To be copied in the server
# mod_spatial_server("spatial_ui_1")
