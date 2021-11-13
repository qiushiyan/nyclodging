#' explore_dataset UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_explore_dataset_ui <- function(id){
  ns <- NS(id)
  tagList(
    includeMarkdown(
      app_sys("app/www/dataset.md")
    )
  )
}
    
#' explore_dataset Server Functions
#'
#' @noRd 
mod_explore_dataset_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_explore_dataset_ui("explore_dataset_ui_1")
    
## To be copied in the server
# mod_explore_dataset_server("explore_dataset_ui_1")
