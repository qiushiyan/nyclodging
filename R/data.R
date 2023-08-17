#' Airbnb listings in New York City, 2019
#'
#' Includes measurements on host, room description, room type, reviews,
#' availability, geographic location.
#'
#' @format A 48,895 × 15 tibble :
#' \describe{
#'   \item{list_id}{listing id}
#'   \item{list_description}{listing description}
#'   \item{host_id}{host id}
#'   \item{host_name}{host name}
#'   \item{neighbourhood_group}{location, e.g., Manhattan, Brooklyn}
#'   \item{neighbourhood}{area, smaller units in location, e.g., Chelsea, East Harlem}
#'   \item{lat}{latitude}
#'   \item{lon}{longitude}
#'   \item{room_type}{type of room, entire room, private room or shared room}
#'   \item{price}{per-day price in dollars}
#'   \item{min_nights}{minimum required nights}
#'   \item{reviews}{number of reviews}
#'   \item{last_review_date}{latest review date}
#'   \item{reviews_per_month}{average number of reviews per month}
#'   \item{available_days}{number of days the listing is available for booking in a year}
#' }
#' @source {Inside Airbnb public data} \url{http://insideairbnb.com/}
#' @source {Kaggle Dataset} \url{https://www.kaggle.com/dgomonov/new-york-city-airbnb-open-data}
"listings"

#' map data combined with NYC tract id in simple features
"map_df"
