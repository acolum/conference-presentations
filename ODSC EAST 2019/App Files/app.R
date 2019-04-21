library(shiny)
library(ggplot2)
library(dplyr)
library(leaflet)
library(lubridate)
library(RColorBrewer)
library(plotly)
library(DT)
library(shinythemes)

load("nasa_fireball.rda")
nasa_fireball$year <- as.numeric(year(nasa_fireball$date))
pal <- colorFactor("Oranges", nasa_fireball$year)

# Define UI
ui <- fluidPage(theme = shinytheme("united"),
                
  # Add titlePanel with window name
  titlePanel("NASA Fireballs, 2003 to 2018",
             windowTitle = "NASA Fireballs"),
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # Inputs
    sidebarPanel(
      
      # Date Range Input for data table and plots
      dateRangeInput(inputId = "date_range",
                   label = "Date Range:",
                   weekstart = 1,
                   start = min(nasa_fireball$date),
                   end = max(nasa_fireball$date),
                   startview = "year"),
      
      ## Scatterplot
      conditionalPanel(condition = "input.tabs == 'Scatterplot'",
                       
        # Select variable for y-axis
        selectInput(inputId = "y", 
                    label = "Y-axis:",
                    choices = c("Optical Radiated Energy" = "energy", 
                                "Impact Energy" = "impact_e", 
                                "Altitude" = "alt", 
                                "Velocity" = "vel"), 
                    selected = "alt"),
        
        # Select variable for x-axis
        selectInput(inputId = "x", 
                    label = "X-axis:",
                    choices = c("Optical Radiated Energy" = "energy", 
                                "Impact Energy" = "impact_e", 
                                "Altitude" = "alt", 
                                "Velocity" = "vel"),
                    selected = "vel"),
        
        # Select variable for color
        selectInput(inputId = "z", 
                    label = "Color by:",
                    choices = c("Latitudinal Direction" = "lat_dir",
                                "Longitudinal Direction" = "lon_dir"),
                    selected = "lat_dir")
      )
      
    ),
    
    # Outputs
    mainPanel(
      
      tabsetPanel(type = "tabs", id = "tabs",
                  
        tabPanel("World Map",
          leafletOutput(outputId = "leaflet_map"),
          br(),
          DT::dataTableOutput(outputId = "fireball_table"),
          downloadButton("download_data","Download")),
        
        tabPanel("Scatterplot",
          plotlyOutput(outputId = "scatterplot")),
        
        tabPanel("Session Info",
          verbatimTextOutput("sessionInfo")),
        
        tabPanel("Feedback",
          h3("Feedback"),
          h5("Contact the developer on ", a("GitHub.",href = "https://github.com/acolum")),
          img(src='fireball.png', length = '50%'))
        
        )
      
      )
    
    )
  
  )
  


# Define server logic 
server <- function(input, output, session) {
  
  # Reactive nasa_fireball: uses a cached expression, updates automatically when input changes
  nasa_fireball_reactive <- reactive({
    nasa_fireball %>%
      filter(date >= input$date_range[1] &
               date <= input$date_range[2])
  })
  
  # Create the leaflet_map object the leafletOutput function is expecting
  output$leaflet_map <- renderLeaflet({
    leaflet(data = nasa_fireball_reactive(), options = leafletOptions(worldCopyJump = T)) %>%
      fitBounds(lng1 = -124.7844079, # Coord bounds for continental US
                lat1 = 49.3457868, 
                lng2 = -66.9513812, 
                lat2 = 24.7433195) %>%
      addTiles() %>%
      addCircleMarkers(lng = ~lon,
                       lat = ~lat,
                       popup = paste("Year:", nasa_fireball_reactive()$year, "<br>",
                                     "Latitude:", nasa_fireball_reactive()$lat, "<br>",
                                     "Longitude:", nasa_fireball_reactive()$lon, "<br>",
                                     "Energy:", nasa_fireball_reactive()$energy),
                       radius = ~sqrt(energy),
                       color = ~pal(year))
  })
  
  # Create the scatterplot object the plotlyOutput function is expecting
  output$scatterplot <- renderPlotly({
    orig_ggplot <- ggplot(data = nasa_fireball_reactive(), aes_string(x = input$x, y = input$y,
                                     color = input$z)) + geom_point() 
    ggplotly(orig_ggplot)
  })
  
  # Create the fireball_table object the DT::dataTableOutput function is expecting
  output$fireball_table <- DT::renderDataTable({
      DT::datatable(data = nasa_fireball_reactive(), # cached expression, only reruns when input changes
                    options = list(pageLength = 10),
                    rownames = F)
  })
  
  # Download dataset to .csv
  output$download_data <- downloadHandler(
    filename = "nasa_fireball.csv",
    content = function(file) {
      write.csv(nasa_fireball_reactive(), file, row.names = FALSE)
    })
  
  # Session Info
  output$sessionInfo <- renderPrint({
    capture.output(sessionInfo())
  })
  
  # End app upon closing the browser
  session$onSessionEnded(stopApp)
  
}

# Run the application 
shinyApp(ui = ui, server = server)