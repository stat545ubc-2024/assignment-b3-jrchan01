library(shiny)
library(DT)
library(gapminder)
library(ggplot2)

# Define UI
ui <- fluidPage(
  titlePanel("Gapminder Data with Filters"),
  
  sidebarLayout(
    sidebarPanel(
      # Multi-selection input for continent
      selectInput("continent", "Select Continent(s):",
                  choices = unique(gapminder$continent), selected = unique(gapminder$continent),
                  multiple = TRUE),
      
      sliderInput("year", "Select Year Range:",
                  min = min(gapminder$year), max = max(gapminder$year),
                  value = range(gapminder$year)),
      
      # Display the number of results
      textOutput("result_count")
    ),
    
    mainPanel(
      # Tabset panel with separate tabs for table, plot, and world map
      tabsetPanel(
        tabPanel("Table", DTOutput("table")),
        tabPanel("Plot", plotOutput("plot")),
        tabPanel("World Map", 
                 img(src = "world_map.png", 
                     alt = "World Map with Continents", 
                     width = "100%"))
      )
    )
  )
)

# Define server logic
server <- function(input, output) {
  # Reactive expression to filter data
  filtered_data <- reactive({
    data <- gapminder
    if
    