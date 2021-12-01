#' text UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @importFrom waiter Waitress

mod_text_ui <- function(id){
  ns <- NS(id)
  
  
  select_ui <- col_8(
    col_12(textInput(ns("description"), 
                     "description of the house", 
                     placeholder = "2b2b with awesome harbour view", 
                     width = "100%")), 
    tags$div(
        col_6(
          sliderInput(ns("lon"), "longitude", min = -74.2, max = -73.7, value = -73.9), 
        ), 
        col_6(
          sliderInput(ns("lat"), "latitude", min = 40.5, max = 40.9, value = 40.7)
        )
    ) %>% tagAppendAttributes(style = "display:flex;"), 
    col_12(
      p("click on the map to quickly pick a location"), 
      leafletOutput(ns("plot"))
    )
  )
  
  predict_ui <- col_4(
    col_12(
      actionButton(
        ns("predict"), 
        "predict price", icon = icon("arrow-down")
      ) %>%
        tags$div(align = "center", style = "padding-left:2em"),
    ),
    HTML("&nbsp;"),
    col_12(
      tags$div(
        p("Predicted price range  "), 
        HTML("&nbsp;"), 
        textOutput(ns("predicted")) %>% tagAppendAttributes(style = "font-weight:bold;"), 
        id = "predict-description"
      ) %>% tagAppendAttributes(style = "display:flex;"), 
      withSpinner(
        tags$div(
          plotOutput(ns("probs")),
          id = "predict-plot"
        )
      )
    )
  )
  
  tagList(
    col_12(
      h5("Predicting price ranges"), 
      p("Describe the listing and pick a location on the map, click on the predict button. We'll predict the mostly likely pricing range based on a multinomial logistic model.
        See ",
        a("here", href = "https://qiushiyan.github.io/nyclodging/articles/modeling.html"), "and ",
        a("here", href = "https://github.com/qiushiyan/nyclodging/blob/main/data-raw/words.R"), " ", 
        "for details")
    ), 
    select_ui, 
    predict_ui 
  )
}
    
#' text Server Functions
#'
#' @noRd 
mod_text_server <- function(id) {
  moduleServer( id, function(input, output, session) {
    ns <- session$ns
    
    waitress <- Waitress$new("#predict-plot", theme = "overlay")
    
    nyc_borough <- nyc_boundaries("borough") %>% st_transform(4326)
    
    classification_model <- readr::read_rds(app_sys("app/www/classification_model.rds"))
    
    result <- rv(
      predicted = NULL, 
      probs = NULL,
      neighbourhood = NULL
    )
    
    house_icon <- makeIcon(
      iconUrl = app_sys("app/www/house_icon.png")
    )
  
    observeEvent(input$plot_click, {
      updateSliderInput(session, "lon", value = isolate(input$plot_click$lng))
      updateSliderInput(session, "lat", value = isolate(input$plot_click$lat))
    })
    
    observeEvent(input$predict, {
      words <- length(strsplit(input$description, " ")[[1]])
      if (words < 5) {
        showFeedbackWarning(
          inputId = "description",
          text = "please enter at least 5 words"
        )  
      } 
      else {
        neighbourhood <- get_neighbourhood(nyc_borough, input$lon, input$lat)
        if (is.na(neighbourhood)) {
          result$predicted <- "I don't want to live outside NYC Pick another location."
        } else {
          waitress$start(h5("predicting price based on location and description ..."))
          df_predicted <- predice_price(classification_model, 
                               input$lon, 
                               input$lat, 
                               neighbourhood, 
                               input$description)
          print(df_predicted)
          result$neighbourhood <- neighbourhood
          result$predicted <- as.character(df_predicted[df_predicted$prob == max(df_predicted$prob), "class", drop = TRUE])
          result$probs <- df_predicted
          waitress$close()
        }
      }
    })
    
    output$predicted <- renderText({
      req(result$predicted)
      result$predicted
    })
    
    output$plot <- renderLeaflet({
        leaflet() %>% 
          addTiles() %>% 
          addMarkers(lng = input$lon, 
                     lat = input$lat,
                     popup = "my awesome house",
                     icon = house_icon)
    
        })
    
    output$probs <- renderPlot({
      req(result$probs)
      
      result$probs %>% 
        ggplot() + 
        geom_col(aes(prob, class)) + 
        theme_minimal() + 
        theme(
          axis.text.y = element_text(size = 14), 
          axis.text.x = element_text(size = 10), 
          title = element_text(size = 18)
        ) + 
        labs(title = "predicted price range", 
             subtitle = sprintf("house in %s", result$neighbourhood),
             y = NULL,
             x = "probability")
    })
    
  })
}
    
## To be copied in the UI
# mod_text_ui("text_ui_1")
    
## To be copied in the server
# mod_text_server("text_ui_1")
