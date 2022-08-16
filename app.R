
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
      addCircles(data = loc,
                 layerId = ~title,
                 lng = ~longitude,
                 lat = ~latitude,
                 label = ~title)

    mymap
  })

  show_loc_popup <- function(title, lng, lat) {

    selected_loc <- loc[loc$title == title, ]

    content <- as.character(tagList(
      tags$strong("Navn: ", selected_loc$title),
      tags$br(),
      sprintf("Lokasjon: %s", selected_loc$location),
      tags$br(),
      sprintf("Beskrivelse: %s", selected_loc$description)
    ))
    leafletProxy("map") |> addPopups(selected_loc$longitude, selected_loc$latitude,
                                     content, layerId = title)
  }

  observe({
    leafletProxy("map") |> clearPopups()
    event <- input$map_shape_click
    if (is.null(event))
      return()

    isolate({
      show_loc_popup(event$id, event$lat, event$lng)
    })
  })

}

# Run the application
shinyApp(ui = ui, server = server)
