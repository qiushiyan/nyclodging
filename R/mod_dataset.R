#' dataset UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @importFrom DT DTOutput renderDT
mod_dataset_ui <- function(id){
  ns <- NS(id)
  tagList(
    col_10(
      includeMarkdown(
        app_sys("app/www/dataset.md")
      ),
      h4("sample table"), 
      DTOutput(ns("datatable"))
    )
  )
}
    
#' dataset Server Functions
#'
#' @noRd 
mod_dataset_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
  
    output$datatable <- renderDT({
      head(listings %>% 
             select(-host_id,
                    -neighbourhood, 
                    -reviews_per_month, 
                    -last_review_date, 
                    -available_days), 
           100) 
      }
    )
  })
}
    

