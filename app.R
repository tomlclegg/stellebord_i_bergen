
library(shiny)
library(leaflet)




# Read in data ------------------------------------------------------------


loc <- read.csv("data/baby_sted_i_bergen.csv")


ui <- fillPage(

  leafletOutput("map", width = "100%", height = "100%")
)

server <- function(input, output) {


  output$map <- renderLeaflet({

    mymap <- leaflet() |>
      addTiles() |>
      addMarkers(data = loc,
                 layerId = ~title,
                 lng = ~longitude,
                 lat = ~latitude,
                 label = ~title,
                 popup = ~sprintf("Navn: %s<br><br>Lokasjon: %s<br><br>Beskrivelse: %s",
                                  loc$title,
                                  loc$location,
                                  loc$description))
    mymap
  })
}

# Run the application
shinyApp(ui = ui, server = server)
