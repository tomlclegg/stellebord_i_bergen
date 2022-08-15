
library(shiny)
library(leaflet)



# Read in data ------------------------------------------------------------


loc <- read.csv("data/baby_sted_i_bergen.csv")


# Define UI for application that draws a histogram
ui <- fluidPage(

    leafletOutput("mymap")
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  output$mymap <- renderLeaflet({

    leaflet() |>
      addTiles() |>
      addMarkers(data = loc,
                 lng = ~longitude,
                 lat = ~latitude,
                 label = ~title,
                 popup = ~description,
                 clusterOptions = markerClusterOptions(showCoverageOnHover = FALSE))

  })

}

# Run the application
shinyApp(ui = ui, server = server)
