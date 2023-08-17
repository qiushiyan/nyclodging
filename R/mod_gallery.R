#' gallery UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom waiter autoWaiter
#' @import echarts4r
#' @import dplyr
#' @import leaflet
#' @importFrom glue glue
mod_gallery_ui <- function(id) {
  ns <- NS(id)
  tagList(
    autoWaiter(ns(c(
      "room_type_bar",
      "reviews_price_scatter",
      "wordcloud_low",
      "wordcloud_high",
      "cor_mat",
      "map"
    ))),
    col_12(h2("Graph Gallery")),
    col_8(
      col_12(
        h5("listings over $1000"),
        p("number represent # of houses cluttered in the area, click on circle to expand and see housing details")
      ) %>% tagAppendAttributes(style = "padding-left:0"),
      leafletOutput(ns("map"))
    ),
    col_4(
      col_12(
        h5("correlation matrix")
      ),
      echarts4rOutput(ns("cor_mat"))
    ),
    col_12(
      br(),
      br()
    ),
    col_8(
      h5("pricing intervals for each room type"),
      p("private and shared room featur low-price houses"),
      echarts4rOutput(ns("room_type_bar"), height = "50vh")
    ),
    col_4(
      h5("pricing vs. # number of reviews"),
      p("n = 5000 sample"),
      echarts4rOutput(ns("reviews_price_scatter"))
    ),
    col_6(
      echarts4rOutput(ns("wordcloud_low"))
    ),
    col_6(
      echarts4rOutput(ns("wordcloud_high"))
    ),
  )
}

#' gallery Server Functions
#'
#' @noRd
mod_gallery_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$room_type_bar <- renderEcharts4r(
      listings_cut %>%
        filter(!is.na(price_cut)) %>%
        group_by(room_type) %>%
        count(price_cut) %>%
        group_by(price_cut) %>%
        e_chart(room_type, reorder = TRUE) %>%
        e_bar(n) %>%
        e_tooltip(trigger = "axis") %>%
        e_legend(orient = "vertical", right = "5", top = "10%") %>%
        e_grid(top = "3%") %>%
        e_labels()
    )

    output$reviews_price_scatter <- renderEcharts4r(
      listings %>%
        slice_sample(n = 5000) %>%
        filter(price <= 500, reviews <= 100) %>%
        group_by(room_type) %>%
        e_chart(reviews, timeline = TRUE) %>%
        e_scatter(price) %>%
        e_loess(price ~ reviews) %>%
        e_legend(show = FALSE) %>%
        e_tooltip(
          trigger = "item",
          formatter = htmlwidgets::JS("
                    function(params){
                      return('price: ' + params.value[0] + '<br />reviews: ' + params.value[1])
                    }
                    ")
        ) %>%
        e_grid(top = "3%")
    )

    output$wordcloud_low <- renderEcharts4r(
      listings_words %>%
        mutate(prop = n / sum(n)) %>%
        filter(price == "lower than 100") %>%
        e_color_range(n, color,
          colors = c(
            "#ffffcc",
            "#c7e9b4",
            "#7fcdbb",
            "#41b6c4",
            "#2c7fb8",
            "#253494"
          )
        ) %>%
        e_charts() %>%
        e_cloud(word, prop, color) %>%
        e_tooltip(formatter = htmlwidgets::JS("
                    function(params){
                      return(params.name + ': ' + params.value.toFixed(3) * 100 + '%')
                    }
                    ")) %>%
        e_title("common words in description", subtext = "price lower than 100")
    )

    output$wordcloud_high <- renderEcharts4r(
      listings_words %>%
        mutate(prop = n / sum(n)) %>%
        filter(price == "higher than 100") %>%
        e_color_range(n, color,
          colors = c(
            "#feedde",
            "#fdd0a2",
            "#fdae6b",
            "#fd8d3c",
            "#e6550d",
            "#a63603"
          )
        ) %>%
        e_charts() %>%
        e_cloud(word, prop, color) %>%
        e_tooltip(formatter = htmlwidgets::JS("
                    function(params){
                      return(params.name + ': ' + params.value.toFixed(3) * 100 + '%')
                    }
                    ")) %>%
        e_title("common words in description", subtext = "price higher than 100")
    )

    output$cor_mat <- renderEcharts4r(
      listings %>%
        na.omit() %>%
        select(!!plot_vars) %>%
        select(where(is.numeric)) %>%
        cor() %>%
        apply(1, round, 2) %>%
        e_charts() %>%
        e_correlations(order = "hclust") %>%
        e_tooltip() %>%
        e_grid(top = "10%")
    )

    output$map <- renderLeaflet(
      listings %>%
        filter(price >= 1000) %>%
        mutate(label = glue("
        <b>price</b>: {scales::dollar(price)}<br>
        <b>description</b>: {list_description}<br>
        <b>room type</b>: {room_type}<br>
        <b>neighorboud</b>: {neighbourhood}<br>
        <b>neighorboud group</b>: {neighbourhood_group}<br>
        <b>reviews</b>: {reviews}<br>
        <b>minimum nights</b>: {min_nights}<br>
        <b>last review date</b>: {last_review_date}<br>
        <b>list id</b>: {list_id}
      ")) %>%
        leaflet() %>%
        addTiles() %>%
        addProviderTiles(providers$Esri.WorldTopoMap) %>%
        addCircleMarkers(
          clusterOptions = markerClusterOptions(maxClusterRadius = 30),
          fill = ~price, popup = ~label
        )
    )
  })
}

## To be copied in the UI
# mod_gallery_ui("gallery_ui_1")

## To be copied in the server
# mod_gallery_server("gallery_ui_1")
