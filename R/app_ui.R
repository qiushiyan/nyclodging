#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom waiter useWaiter useWaitress
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    bootstrapLib(bslib::bs_theme(bootswatch = "yeti")), 
    useWaiter(), 
    useWaitress(), 
    # Your application UI logic 
    tagList(
      nav_(
        "Explore Airbnb listings in NYC",
        c(
          "dataset" = "Dataset",
          "distribution" = "Distribution",
          "relationship" = "Relationship",
          "spatial" = "Spatial Analysis",
          "text" = "Text Analysis",
          "gallery" = "Gallery" 
          
        )
      ), 
      tags$div(
        class = "container", 
        fluidRow(
          id = "dataset",
          mod_dataset_ui("about")
        ) %>% undisplay(), 
        fluidRow(
          id = "distribution", 
          mod_dist_ui("dist")
        ) %>% undisplay(),
        fluidRow(
          id = "relationship", 
          mod_relation_ui("relation")
        ) %>% undisplay(),
        fluidRow(
          id = "spatial", 
          mod_spatial_ui("spatial")
        ) %>% undisplay(),
        fluidRow(
          id = "text", 
          mod_text_ui("text")
        ) %>% undisplay(),
        fluidRow(
          id = "gallery",
          mod_gallery_ui("gallery"), 
        ) %>% undisplay() 
      )
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'nyclodging'
    ),
    tags$title("Airbnb listings in NYC"),
    # Add here all the external resources
    # If you have a custom.css in the inst/app/www
    # Or for example, you can add shinyalert::useShinyalert() here
    tags$link(
      rel="stylesheet",
      type="text/css",
      href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css",
      integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T",
      crossorigin="anonymous"
    ),
    tags$script(
      src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js",
      integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM",
      crossorigin="anonymous"
    ),
    tags$link(
      rel="stylesheet", 
      type="text/css", 
      href="www/custom.css"
    ), 
    tags$script(src = "www/script.js"),
    tags$script(src = "www/utils.js"),
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

