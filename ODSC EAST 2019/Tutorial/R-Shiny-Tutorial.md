# Data Visualization with R Shiny

## ODSC East 2019

### Alyssa Columbus

# Before the Tutorial

## First off, thank you so much for signing up for my tutorial.

To be ready on the day of the tutorial, please have R, RStudio, and the following packages installed:


```r
# If you don't have one of these packages, 
# install the package by typing install.packages("package") into the Console.
library(shiny)
library(ggplot2)
library(dplyr)
library(leaflet)
library(lubridate)
library(RColorBrewer)
library(plotly)
library(DT)
library(shinythemes)
```

As you can see above, we're going to let the `tidyverse` packages do the heavy lifting in this app, as they work the most efficiently with each other. Since `shiny` is like a sister package to the `tidyverse`, this also means that `tidyverse` packages work the most efficiently with `shiny`.

On the day of the tutorial, please have RStudio, your preferred internet browser, and [all provided tutorial files (linked here)](https://github.com/acolum/conference-presentations/tree/master/ODSC%20EAST%202019) open and ready.

## This is the (tentative and flexible) schedule:
  
|    Time   |                               Session                              |  Duration  |
|-----------|--------------------------------------------------------------------|------------|
| 2:00-3:00 | Session 1: Shiny Training: Introduction and Shiny Basics           | 60 minutes |
| 3:00-3:15 | Break                                                              | 15 minutes |
| 3:15-4:15 | Session 2: Constructing the Module: Inputs, Outputs, and Rendering | 60 minutes |
| 4:15-4:30 | Break                                                              | 15 minutes |
| 4:30-5:30 | Session 3: Preparing for Launch: Customization and Deployment      | 60 minutes |
| 5:30-6:00 | Q & A                                                              | 30 minutes |

Together, we're going to learn how to build [this R Shiny application](https://acolumbus.shinyapps.io/OSCON_ShinyApp/) with essential components and features including:

* a `leaflet` map

* a scatterplot (with `plotly` interactivity)

* a data table (with `DT` interactivity)

* `shiny` reactivity

* R session info

* HTML customization

* tabPanels for organization

To build this app, we're going to use a dataset pulled directly from an [open NASA data repository!](https://data.nasa.gov/Space-Science/Fireball-And-Bolide-Reports/mc52-syum) This dataset is a chronological summary of 500 fireball sightings from April 2003 to January 2018. 

In the above schedule, I'm following the workflow I and many other shiny developers have used for the past few years, which works very smoothly. 

### Best practices (like this workflow) for Shiny app development and deployment will be integrated into all parts of this presentation.

Let's start off with 3:

1. When debugging, always run the entire script, not just up to the point where you're developing code, since you can only see where you went wrong by running the entire application.

2. Sometimes the best way to see what's wrong is to run the app and review the error.

3. Watch out for commas!

## Note for the day of the tutorial:

* If you ever think I'm going too fast during the tutorial, please raise your hand, and I'll slow down. Also feel free to ask me to explain something again in a different way if you didn't understand it the way I explained it the first time.

* During the breaks, since the conference organizers and I highly encourage networking at this event, I'd encourage you to spend a few minutes each break introducing yourselves to people around you, saying what company or organization you're from, and maybe what you're looking to learn/are learning from this tutorial. 

# Tutorial Session 1: Shiny Training

## What is R Shiny?

`Shiny` is an R package that enables you to build interactive web apps using both the statistical power of R and the interactivity of the modern web. An excellent alternative to spreadsheets and printed visualizations, R Shiny saves space and time in constructing and sharing data visualizations and statistical analyses.

## What's in a shiny app?


```r
library(shiny) # start by loading the necessary packages (shiny is always necessary)

ui <- fluidPage( # lay out the UI with a ui object that controls the appearance of our app 

  )

server <- function(input,output) { # server object contains instructions needed to build the app

  }

shinyApp(ui = ui, server = server) # combines ui and server objects to create the Shiny app
```

### Additional comments about the UI

Using this `fluidPage` layout, the app uses all available browser width, so you, the app developers, don't need to worry about defining relative widths for individual app components. Also, under the hood, `shiny` implements layout features available in Bootstrap 2, a popular HTML/CSS framework, but the nice thing about working with `shiny` is that no HTML, CSS, or even Bootstrap experience is necessary to create informative apps!

### Additional comments about the server

The server is generally where all of the calculations, calls, and backend actions take place in a `shiny` app.

**Question for the Audience!**

Which is *not* generally a part of the Shiny app architecture?

* A function that installs an R package

* User interface

* Server function

* A function that creates Shiny App objects

## Starting a new R Shiny app

In RStudio, go to `File > New File > Shiny Web App`. Name your application, save it in your desired directory, and just for this tutorial, save it as a single file (app.R).

You now have a sample R Shiny app to customize and make your own! Notice that the basic anatomy of an R Shiny app is represented here with the ui, server, and runApp function. Notice also that there are some additional inputs and outputs like a sliding input and histogram plot output. In our app, we'll make inputs and outputs similar to these.

### Delete all comments and code that aren't the bare bones of the shiny app.

Your app should then look like this:

```r
library(shiny)

ui <- fluidPage(
   sidebarLayout(
      sidebarPanel(
      ),
      mainPanel(
      )
   )
)

server <- function(input, output) {
   })
}

shinyApp(ui = ui, server = server)
```

### Load the packages into the very top of the shiny app.


```r
# If you don't have one of these packages, 
# install the package by typing install.packages("package") into the Console.
library(shiny)
library(ggplot2)
library(dplyr)
library(leaflet)
library(lubridate)
library(RColorBrewer)
library(plotly)
library(DT)
library(shinythemes)
```

### Load the data into the shiny app.

1. Copy over the NASA fireballs dataset into the same directory as your Shiny app. 

2. Load the NASA fireballs dataset below the loaded packages and above the ui and server components so that the data can be used in both.


```r
load("nasa_fireball.rda")
```

#### Best Practice: Have your data saved as a .rda file, since it takes up less space in R and ultimately makes your shiny app faster.

## Data Manipulation and UI/Server Customization


```r
# load("nasa_fireball.rda") # commented here to show placement

nasa_fireball$year <- as.numeric(year(nasa_fireball$date)) # add a new column to nasa_fireball with the year of each observation (with lubridate)
pal <- colorFactor("Oranges", nasa_fireball$year) # color palette funct. for leaflet; allows map to show diff. shades of orange for each year
# "Oranges" is a palette in the "RColorBrewer" package

# Define UI
ui <- fluidPage( 
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # Inputs
    sidebarPanel(
      
      ## Scatterplot
      # Select variable for y-axis
      selectInput(inputId = "y", # input Id to match with output that depends on this input widget
                  label = "Y-axis:", # label above this input widget in the sidebar
                  choices = c("energy", "impact_e", "alt", "vel"), # choices available for users to pick from
                  selected = "alt"), # selected = default selection; Watch for commas!
      
      # Select variable for x-axis
      selectInput(inputId = "x",
                  label = "X-axis:",
                  choices = c("energy", "impact_e", "alt", "vel"),
                  selected = "vel"), # Watch for commas!
      
      # Select variable for color
      selectInput(inputId = "z",
                  label = "Color by:",
                  choices = c("lat_dir","lon_dir"),
                  selected = "lat_dir")
    ),
    # Outputs
    mainPanel( # add outputs to the ui defining where they should be
          leafletOutput(outputId = "leaflet_map"), # display the leaflet_map object
          plotOutput(outputId = "scatterplot") # display the scatterplot object
    )
  )
)

# Define server logic
server <- function(input, output) { 
  
  # Create the leaflet_map object the leafletOutput function is expecting
  output$leaflet_map <- renderLeaflet({     # uses nasa_fireball data 
    leaflet(data = nasa_fireball, options = leafletOptions(worldCopyJump = T)) %>% # worldCopyJump = T ensures no jumps when moving around the world
      fitBounds(lng1 = -124.7844079, # coordinate bounds for continental US; centers the map on the continental US
                lat1 = 49.3457868,
                lng2 = -66.9513812,
                lat2 = 24.7433195) %>%
      addTiles() %>%                 # customize style of map
      addCircleMarkers(lng = ~lon,   # add circle markers for each fireball, plotting them at longitude and latitude coordinates
                       lat = ~lat,
                       popup = paste("Year:", nasa_fireball$year, "<br>",    # display year, lat, lon, energy when circle marker is clicked
                                     "Latitude:", nasa_fireball$lat, "<br>",
                                     "Longitude:", nasa_fireball$lon, "<br>",
                                     "Energy:", nasa_fireball$energy),
                       radius = ~sqrt(energy),   # size of each circle marker is the square root of its energy level
                       color = ~pal(year))       # color of each circle is dependent on the pal function defined at the top (with RColorBrewer)
  })
  
  # Create the scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({   # uses nasa_fireball data
    ggplot(data = nasa_fireball, aes_string(x = input$x, y = input$y, # x, y, and color layers of the plot depend on user input
                                     color = input$z)) +
      geom_point()  # add points based on inputs x, y, and color to the plot
  })
  
}
```

### Best practice: Always make sure your object that you want to show in your Shiny app is in both your ui and server objects. 

If it's not in both, it won't be displayed.

**Question for the Audience!**

Which of the following is *not* true about server functions?

* Input values should be referred to as `input$*`

* Objects to be displayed should be saved to `output$*`

* Reactive outputs should be built with `render*()` functions

* Server functions should include a call to `runApp()`

## Run the app!

### Best Practice: Run/test your app externally in your browser to see how it truly looks before it's deployed.

This will also correct some errors with downloading content from the app. Since I'm not sure how strong your internet connection will be over the course of this tutorial, though, I'm going to suggest we just run our apps in the window, or via the default option, which requires no internet connection.

## Extend the UI Further

Let's extend the UI further to add some additional ease for the user and interactivity with the scatterplot (`ggplot`).

### Best Practice: Add human-readable labels to your inputs.

In our app, add human-readable labels to scatterplot's input widgets, since users probably don't know what `impact_e`, `alt`, and `vel` mean.

In the ui, the `choices` option for each scatterplot widget should have the human-readable labels on the left and corresponding machine labels on the right, like below:


```r
                  choices = c("Optical Radiated Energy" = "energy",
                              "Impact Energy" = "impact_e",
                              "Altitude" = "alt",
                              "Velocity" = "vel"),
                              selected = "alt"),
...
                  choices = c("Optical Radiated Energy" = "energy",
                              "Impact Energy" = "impact_e",
                              "Altitude" = "alt",
                              "Velocity" = "vel"),
                              selected = "vel"),
...
                  choices = c("Latitudinal Direction" = "lat_dir",
                              "Longitudinal Direction" = "lon_dir"),
                              selected = "lat_dir")
```

### Integrate `plotly` to make the ggplot interactive

In the ui mainPanel, replace the function `plotOutput` with `plotlyOutput`. Also, in the server, replace `renderPlot()` with `renderPlotly()`. 

In the same place in the server, assign the ggplot to the variable `orig_ggplot` and plotly-ify this ggplot by typing `ggplotly(orig_ggplot)`. Your server `output$scatterplot` should look like this:


```r
  # Create the scatterplot object the plotlyOutput function is expecting
  output$scatterplot <- renderPlotly({
    orig_ggplot <- ggplot(data = nasa_fireball_reactive(), aes_string(x = input$x, y = input$y,
                                     color = input$z)) + geom_point() 
    ggplotly(orig_ggplot)
  })
```

**Note:** More information about interactive `plotly` graphics in R can be found in [Carson Sievert's free online book](https://plotly-r.com/).

## Recap of the Basics

* Every shiny app has a webpage that the user visits, and behind that webpage is a computer/server that serves this webpage by running R.

  * When running your app locally, the computer serving your app is your computer.
  
  * When your app is deployed, the computer running your app is a web server.
  
* Each app is comprised of 2 components: a UI and a server.

  * The UI is ultimately built with HTML, CSS, and JavaScript; however, you as a shiny developer, do not need to know these languages to build shiny apps, as these languages are wrapped with R and the `shiny` package. If you are an advanced user and do know these languages, there are no limits for customization.
  
  * The server function contains the instructions to map user inputs to outputs.
  
* I often think of the UI as containing syntax specific to Shiny, and the server as containing R code you might already be familiar with -- with some Shiny functions added to achieve reactivity.

* When running your app, it is a best practice to run it externally, but in this tutorial, we're running it in another RStudio window.

* When you are done with an app, you can terminate the session by closing the window and clicking the red stop button in your viewer pane above the console.

# Tutorial Session 2: Constructing the Module

## Reactive Flow

One familiar way of thinking about the Reactive Flow is in the context of a spreadsheet (e.g. Google Sheets, Microsoft Office Excel). 

Suppose you write a value into a cell in a spreadsheet, and in another cell, you write a formula that depends on that cell. First the formula is calculated with the value you originally typed. Then, when you change the value of the original cell, the result of the formula will automatically update, or react, to this change. In a shiny app, reactivity happens in a similar fashion.

In our Shiny app that we built in the last session, we have a `selectInput` with the inputID `z`. No matter what the user inputs, the inputID always stores it as `z`, so whenever the user selects a different option from the list, the value of `z` is updated in the input (`input$`) list.

In a shiny application, there's no need to explicitly define relationships between inputs and outputs and tell R what to do when each input changes. Shiny's reactivity automatically handles these details for you.

## UI Inputs

Referring to the shiny cheatsheet, there are several different types of ui inputs you can place in your shiny app for pretty much any kind of data object you can think of.

### Add more UI inputs to our app

Let's add an interactive datatable to our app's display, so that we can see the data along with the visualizations!

#### Best Practice: If you want to add a datatable to your app, make it interactive and sortable by using the `DT` package.

In the ui's mainPanel, below the other outputs, add:


```r
      DT::dataTableOutput(outputID = "fireball_table")
```

Add the corresponding `DT::renderDataTable({})` to the server:


```r
  output$fireball_table <- DT::renderDataTable({
      DT::datatable(data = nasa_fireball,
                    options = list(pageLength = 10),
                    rownames = F)
  })
```

Let's also add a `dateRangeInput()` to our app that restricts our visualizations and datatable to only showing data within a user's specified date range. To do this we have to sort and make our original data, `nasa_fireball.rda`, reactive. More on reactivity and its inner workings will be covered later in the tutorial.

Add the `dateRangeInput()` widget as the first widget in the ui, since all other widgets are now depending on the input value in this widget:


```r
#    sidebarPanel(  # commented here for placement
      # Date Range Input for data table and plots
      dateRangeInput(inputId = "date_range",
                   label = "Date Range:",
                   weekstart = 1, 
                   start = min(nasa_fireball$date), # starts on first date in dataset
                   end = max(nasa_fireball$date), # ends on last date in dataset
                   startview = "year"), # conveniently sort by year first instead of day, since data has a large range of dates
```

In the server, before all outputs, make `nasa_fireball.rda` reactive:


```r
  nasa_fireball_reactive <- reactive({    #  Reactive nasa_fireball: uses a cached expression, updates automatically when input changes
    nasa_fireball %>%
      filter(date >= input$date_range[1] &
               date <= input$date_range[2])
  })
```

#### Best Practice: Make the dataset used in your Shiny app reactive to enable the visualizations depending on your dataset to be updated whenever the dataset is updated.

Replace `nasa_fireball` in each `output$*` with `nasa_fireball_reactive()`. `nasa_fireball_reactive()` has parentheses at the end, because it is a reactive dataset and is implicitly treated as a no-argument function. (More information about this and reactivity in general will be covered later in the tutorial.)

For example, `output$fireball_table` should look like this:


```r
  output$fireball_table <- DT::renderDataTable({
      DT::datatable(data = nasa_fireball_reactive(), # cached expression, only reruns when input changes
                    options = list(pageLength = 10),
                    rownames = F)
  })
```

### Best Practices not applicable in this app, but still good to know:

Notice when we delete the date inputs (or any other inputs for that matter) all of the outputs disappear and we don't get an error message, which is nice. Other inputs, when you delete them won't be so nice, though, and will throw an error message, like `numericInput()` for example. That's when you would use the `req()` function.

Type `req(input$*)` before any calculation/manipulation in your reactive rendering function in the server, and you won't get an error message anymore, just a nice blank output like we have in our Shiny app.

Also, say for example you wanted to select more than one input from these lists of variables to sort the datatable. You would go into your `selectInput()` widget and add `multiple = T` as an option, along with adding `req(input$*)` in your reactive `render*()` function in your server.

## UI Outputs

Referring to the shiny cheatsheet, there are several different types of ui outputs you can place in your shiny app for pretty much any kind of data object you can think of.

### Add more UI outputs to our app

#### Best Practice: Always add your session information to make your app more reproducible and easier to troubleshoot.

In the ui mainPanel, let's add our session information below all of the other outputs:


```r
      # verbatimtextOutput of the sessionInfo
      h5("My Session Information:"), verbatimTextOutput("sessionInfo")
```

Don't forget to add the corresponding `render*()` in the server!


```r
 # Session Info
  output$sessionInfo <- renderPrint({
    capture.output(sessionInfo())
  })
```

#### Best Practice: If your data has permission to be public, always make it downloadable in your Shiny app.

In the ui mainPanel, immediately below the `DT::dataTableOutput()`, add a `downloadButton()`:


```r
      downloadButton("download_data","Download"),
```

Be sure to add the corresponding `downloadHandler()` in the server.


```r
  # Download dataset to .csv
  output$download_data <- downloadHandler(
    filename = "nasa_fireball.csv",
    content = function(file) {
      write.csv(nasa_fireball_reactive(), file, row.names = FALSE)
    })
```

## The Theory of Reactivity

Reactivity makes shiny apps more efficient but also more complex.
There are three kinds of objects in reactive programming: **reactive sources, conductors, and endpoints.** 

1. **Reactive sources** are typically user inputs that come through a browser interface (`input$*`). 

2. **Reactive endpoints** are objects that appear in a user's browser window, such as a plot or table of values (`output$*`). One reactive source can be connected to multiple endpoints and vice versa. 

3. **Reactive conductors** (`reactive()`) are reactive components between sources and endpoints. A conductor can be both a child and parent (both being a dependent and having dependents) whereas a source can only be a parent (can only have dependents) and an endpoint can only be a child (can only be a dependent).

> We've already made use of these reactive expressions to build our app, updating the backend dataframe, visualized dataframe, map, ggplot, and download every time we select a new date range.

**Question for the Audience!**

The `nasa_fireball_reactive()` expression in our app is a...

* Reactive source

* Reactive conductor

* Reactive endpoint

By using a reactive expression for the subsetted data frame, we were able to get away with subsetting the data only once, but using it 4 times. Reactive conductors, in general, are very nice, because:

1. You don't have to repeat yourself and have copy-and-paste code, and

2. You can decompose large, complex calculations into smaller pieces to make them more understandable. 

These advantages of reactive conductors are similar to those gained by decomposing a large, complex R script into a series of smaller functions that build on each other.

### Functions vs. Reactives

Every time you call a **function,** R will evaluate it.

**Reactive expressions** are lazy, and will only execute when their input changes. Even if you call a **reactive expression** multiple times, it only re-executes when its inputs change.

### Reactlog
Using many reactive expressions in your app can create a complicated dependency structure in your app. 
The reactlog is a graphical representation of this dependency structure, and it also gives you very detailed information about what's going on under the hood as Shiny goes through and evaluates your application.

### Best Practice: View your reactlog.

In a fresh R session, type: 


```r
options(shiny.reactlog = TRUE)
```

Then launch your app as you normally would, and press CTRL + F3 in the app to view your reactlog.
More information about reactlogs can be found in the [RStudio Documentation](https://shiny.rstudio.com/reference/shiny/1.1.0/showReactLog.html).

**Important Advice from RStudio:** "For security and performance reasons, do not enable `shiny.reactlog` in production environments. When the option is enabled, it's possible for any user of your app to see at least some of the source code of your reactive expressions and observers."

### Reactors vs. Observers

#### Implementation of reactive sources (e.g. `input$*`): 

Reactive sources contain many individual reactive values that are set by input from the web browser.

#### Implementation of reactive conductors (e.g. `reactive()`):

Reactive conductors can access reactive values or other reactive expressions, and they return a value. This is useful for caching the results of any procedure that happens in response to user input.

#### Implementation of reactive endpoints (e.g. `observe()`, `output$*`): 

An `output$*` object is an observer. What's going on under the hood is that a render function returns a reactive expression, and when you assign it to an `output$*` value, Shiny automatically creates an observer that uses the reactive expression. Observers can access reactive sources and reactive expressions, but they don't return a value. They are primarily used for their side effects, including sending data to a web browser.

### Synopsis of Reactors vs. Observers

**Similarities:** Both store expressions that can be executed.

**Differences:** 

* Reactive expressions return values, observers don't.

* Observers (and endpoints in general) respond to changes in their dependencies, but reactive expressions (and conductors in general) do not.

* Reactive expressions must not have side effects, while observers are only useful for their side effects.

**Most importantly:**

* `reactive()` is for calculating values, without side effects.

* `observe()` is for performing actions, with side effects.

* Do not use `observe()` when calculating a value, and especially don't use `reactive()` for performing actions with side effects.

**Question for the Audience!**

Which of the following does *not* have a side effect?

* `var <- 125`

* `source("script.R")`

* `library(ggplot2)`

* `2/3`

**Question for the Audience!**

Which of the following functions has a side effect?

* `function(a, b) { log(a/b) }`

* `function(data) { hist(data, plot = TRUE) }`

* `function() { read.tsv("~/data/raw.txt") }`

* `function(x) { summary(x) }`

### 3 Main Ideas of Reactivity

1. Reactives are equivalent to no-argument functions. Think about them as simultaneously functions and variables that can depend on user input and other reactives.

2. Reactives are for reactive values and expressions; observers are for their side effects. 

3. Do not define a `reactive()` inside a `render*()` function.

# Tutorial Session 3: Preparing for Launch

## Interface Builder Functions, or HTML Expressions in R Shiny

Type `names(tags)` into the console to see all of the HTML tags available in R Shiny.

Here's a few examples: 


```r
tags$b("This is my first R Shiny app!") # bold tag
tags$h1("Large: H1 Heading") # header tags
tags$h2("Medium: H2 Heading")
tags$h3("Small: H3 Heading")
tags$br() # line break
tags$hr() # horizontal line
tags$a("R Shiny Gallery", href = "https://shiny.rstudio.com/gallery/") # linked text
```

### Add HTML to our Shiny app

#### Best Practice: Have some way for people to contact you about issues in the app. Add your email, Twitter, GitHub, etc. and a fun image!
This can also enable people to find other great development work you've done.

Add this in the mainPanel, below all of the other outputs:


```r
h3("Feedback"),
h5("Contact the developer on ", a("GitHub.",href = "https://github.com/acolum")),
img(src='fireball.png', length = '50%')
```

## Layout Panels

Use panels to group multiple elements into a single element that has its own properties.This is especially useful and important for complex apps with a large number of inputs and outputs such that it might not be clear to the user where to get started.

Here's a few examples: 


```r
sidebarPanel() # create a sidebarPanel with input controls to be passed to the sidebarLayout
mainPanel() # create a mainPanel with outputs from the sidebarPanel inputs
wellPanel() # emphasize separations between sidebarPanels
conditionalPanel() # panel that only appears if a condition is met (e.g. only on a certain filter or tab)
```

### Add a titlePanel with window name to our app


```r
# ui <- fluidPage( commented here to show placement
  # Add titlePanel with window name
  titlePanel("NASA Fireballs, 2003 to 2018",
              windowTitle = "NASA Fireballs"),
# sidebarLayout( commented here to show placement
```

## Tabs and Tabsets

Tabs organize an app into smaller sections so that the amount of information displayed to the user isn't too overwhelming. Since our output is a bit overwhelming, we'll add a few tabs to organize and split it up.

### Add a tabsetPanel to the mainPanel


```r
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
```

#### Best practice: Add icons to your tabs.

You can add icons to your tabs from [Fontawesome](https://fontawesome.com/icons?d=gallery) and [Glyphicons](http://glyphicons.com/). Note that since our tabPanels are not within a navbarPage, we can't do this in our app today, but to add an icon, you would simply type:


```r
tabPanel("World Map", icon = icon("globe-americas"),
         leafletOutput(outputId = "leaflet_map"),
         ...
)
```

### Add a conditionalPanel

To only display the scatterplot input widgets on the "Scatterplot" tab, we're going to add a conditionalPanel:


```r
  #                 startview = "year"), commented here to show placement
      conditionalPanel(condition = "input.tabs == 'Scatterplot'",
      ## Scatterplot
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
  # ), commented here to show placement
```

## Add a shinytheme 

Shinythemes customize the overall theme and look of a Shiny app. [Refer to RStudio's documentation for more information.](https://rstudio.github.io/shinythemes/)

### Add an orange theme to our fireball app


```r
ui <- fluidPage(theme = shinytheme("united"),
                ...
```
                
## Congratulations, your first app is complete!

## Share Your App with the World!

So far, we've just been running (and hosting) our shiny apps locally. To share them with the world, we need to host them on another server. Here's 4 ways for you to do this:

1. **Host on shinyapps.io**

RStudio provides a service called shinyapps.io which lets you host your apps for free. It is integrated into RStudio so that you can publish your apps with the click of a button, and it has a free version. The free version allows a certain number of apps per user and a certain number of activity on each app, but it should be good enough for just starting out with Shiny. It also lets you see some basic stats about the usage of your app.

Hosting your app on shinyapps.io is the easy and recommended way of getting your app online. Go to www.shinyapps.io and sign up for an account. When you're ready to publish your app, click on the "Publish Application" button in RStudio and follow their instructions. You might be asked to install a couple packages if it's your first time.

After a successful deployment to shinyapps.io, you will be redirected to your app in the browser. You can use that URL to show off to your boss or family and friends what a cool app you wrote.

2. **Host on a Shiny server**

The other option for hosting your app is on your own private Shiny server, which is also free. Instead of RStudio hosting the app for you, you'll have it on your own private server. This means you'll have a lot more freedom and flexibility, but it also means you'll need to have a server and be comfortable administering a server. I currently host all my apps on my own Shiny server just because I like having the extra control, but when I first learned about Shiny I used shinyapps.io for several months.

3. **Host on an AWS EC2 Instance**

This hosting environment is fast, efficient, and I recommend it if your company doesn't have an RStudio Connect contract. Work with your IT department and use the tutorial linked below in "Additional Resources" to set this up.

4. **Host on RStudio Connect**

[RStudio Connect](https://www.rstudio.com/products/connect/) is an enterprise publishing platform for the work teams create in R and Python. If your company (like my company, Pacific Life) has a contract here, you can host R Shiny applications, R Markdown reports, Jupyter Notebooks, and more on one convenient, private server.

## Shiny in Style! - Additional Features of R Shiny

- **Shiny in RMarkdown:** You can include Shiny inputs and outputs in an RMarkdown document! This means that your RMarkdown document can be interactive. See [Shiny Interactive Elements in RMarkdown](https://bookdown.org/yihui/rmarkdown/shiny-documents.html) for more information.

- **Shiny Dashboards:** You can build a Shiny dashboard in a very similar fashion to the app we built today. See the documentation for the [dashboard packages below](#shiny-dashboards) for more information.

- **Shiny Loading Animations:** See the resources below for more information on how to add loading animations for the overall app and individual components.

- **If your app has a large codebase:** Split app.R into ui.R, server.R, and global.R. ui.R and server.R store ui and server objects respectively.
Use the global.R file to store all objects that you want to have available to both your ui and server objects (e.g. packages, data, custom-built functions, etc.)

- **When testing your app in an external browser:** If you close your browser window and the app is still running, you need to manually press "Esc" to kill it. By adding a single line to the end of your server code:  


```r
session$onSessionEnded(stopApp)
```

your Shiny app will automatically stop running whenever your browser tab (or any session) is closed.

## Additional Shiny Resources

### General

- [Shiny Cheatsheet](https://shiny.rstudio.com/images/shiny-cheatsheet.pdf)

- <https://shiny.rstudio.com>

- [RStudio Shiny Webinars](https://www.rstudio.com/resources/webinars/#shinyessentials)

- [Awesome R Shiny Tutorials and Resources](https://github.com/grabear/awesome-rshiny)

### Appearance and Layout

- [Application Layout Guide](https://shiny.rstudio.com/articles/layout-guide.html)

- [Shiny Loading Animations](https://github.com/andrewsali/shinycssloaders)

- [More Shiny Loading Animations](https://github.com/emitanaka/shinycustomloader)

- [HTML Templates](https://shiny.rstudio.com/articles/templates.html)

- [Integrating React.js and Shiny](https://resources.rstudio.com/shiny/integrating-react-js-and-shiny)

### Deployment and Hosting

- [Hosting Shiny Apps on Your Own Server](http://www.kimberlycoffey.com/blog/2016/2/13/mlz90wjw0k76446xkg262prvjp0l8u)

- [Hosting Shiny Apps on an AWS EC2 Instance](https://towardsdatascience.com/how-to-host-a-r-shiny-app-on-aws-cloud-in-7-simple-steps-5595e7885722)

### Production 

- [Shiny in Production](https://github.com/kellobri/spc-app)

- [Building Big Shiny Apps](https://rtask.thinkr.fr/blog/building-big-shiny-apps-a-workflow-1/)

- [Make Shiny fast by doing as little work as possible](https://www.rstudio.com/resources/videos/make-shiny-fast-by-doing-as-little-work-as-possible/)

- [Plot Caching](https://blog.rstudio.com/2018/11/13/shiny-1-2-0/)

- [Scoping Rules for Shiny Apps](http://shiny.rstudio.com/articles/scoping.html)

### Utilities

- [Modularizing Shiny App Code](https://shiny.rstudio.com/articles/modules.html)

- [Effective Use of Shiny Modules](https://rpodcast.github.io/rsconf-2019/#1)

- [Bookmarking State](https://shiny.rstudio.com/articles/bookmarking-state.html)

- [Bookmarking and Modules](https://shiny.rstudio.com/articles/bookmarking-modules.html)

- [Advanced Bookmarking](https://shiny.rstudio.com/articles/advanced-bookmarking.html)

- [Shiny Interactive Elements in RMarkdown](https://bookdown.org/yihui/rmarkdown/shiny-documents.html)

- [How Shiny's Reactivity Works](http://shiny.rstudio.com/articles/execution-scheduling.html)

### Testing and Error Messages

- [Debugging Shiny Applications](https://shiny.rstudio.com/articles/debugging.html)

- [Reactlog 2.0 - Debugging the State of Shiny](https://github.com/schloerke/presentation-2019-01-18-reactlog)

- [Testing Shiny Applications with `shinytest`](https://shiny.rstudio.com/articles/shinytest.html)

- [Sanitizing Error Messages](https://shiny.rstudio.com/articles/sanitize-errors.html)

- [Write error messages for your UI with `validate`](https://shiny.rstudio.com/articles/validation.html)

## Add-on Packages for Shiny

### Appearance and Layout

- `shinythemes` - adds Bootswatch CSS themes to Shiny applications

- `shinycssloaders` - add CSS loader animations to `shiny` outputs

- `shinycustomloader` - add a custom loader for R Shiny

- `shinyBS` - Twitter Bootstrap Components for `shiny`

- `bsplus` - `shiny` and R Markdown addons to Bootstrap 3

- `RLumShiny` - provides access to bootstraps tooltip and popover functionality and contains the jscolor.js library with a custom `shiny` output binding

- `shinybulma` - bulma.io for `shiny`

- `fullPage` - fullPage.js, pagePiling.js and multiScroll.js for `shiny`

### Dashboards {#shiny-dashboards}

- `shinydashboard` - wraps the Admin LTE library for creating dashboard interfaces

- `flexdashboard` - R Markdown alternative to `shinydashboard` for interactive dashboards

- `shinydashboardPlus`- extensions for `shinydashboard`

- `argonDash` - argon dashboard template

- `bs4Dash` - Bootstrap 4 `shinydashboard` using AdminLTE3

### Utilities

- `shinytest` - provides tools for creating and running automated tests on `shiny` applications

- `shinyloadtest` - tools for load testing `shiny` applications

- `shinyjs` - extends `shiny` and provides utilities for calling custom JavaScript bindings

- `shinyEffects` - fancy CSS effects for `shiny`

- `shinyWidgets` - extend widgets available in `shiny`

- `crosstalk` - enables cross-widget interaction

- `loggit` - adds logging to R (`shiny`)

- `plumbr` - create web APIs that call R

- `reticulate` - R interface to Python modules, classes, and functions

- `promises` - enables asynchronous evaluation of R code

### Visual Representations of Data

- `leaflet` - wraps the leaflet JavaScript library for interactive, mobile-friendly web-mapping

- `DT` - interactive tables via DataTables.js

- `gt` - easily generate information-rich, publication-quality tables from R

- `kable` - create tables in LaTeX, HTML, Markdown and reStructuredText 

- `kableExtra` - construct complex tables with `kable` and pipe (` %>% `) syntax

- `dygraphs` - interactive time-series charts

- `highcharter` - interactive web graphics via highcharts.js

- `ggplot2` - system for declaratively creating graphics based on *The Grammar of Graphics*

- `ggvis` - similar to `ggplot2`, but the plots are focused on being web-based and are more interactive

- `googleCharts` - Google Charts bindings for `shiny`

- `googleVis` - R interface to Google's chart tools

- `plotly` - interactive web graphics via plotly.js

### And many more! Explore them here: <http://gallery.htmlwidgets.org>

# Thank you for attending my tutorial on "Data Visualization with R Shiny."

Remember to use the best practices I taught you in this tutorial, but also don't be afraid to be creative and have fun in your Shiny app design.
Thanks so much for listening and following along, and I hope you'll have a great rest of your week at ODSC East!

<hr />

A work by [Alyssa Columbus](https://alyssacolumbus.com/).

*[hello@alyssacolumbus.com](mailto:hello@alyssacolumbus.com)*
