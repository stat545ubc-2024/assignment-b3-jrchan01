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
                 tags$img(src = "https://upload.wikimedia.org/wikipedia/commons/2/2d/Continental_models-Australia.gif", 
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
    if (length(input$continent) > 0) {
      data <- data[data$continent %in% input$continent, ]
    }
    data <- data[data$year >= input$year[1] & data$year <= input$year[2], ]
    data
  })
  
  # Output the filtered table
  output$table <- renderDT({
    datatable(filtered_data(), filter = 'top', options = list(pageLength = 10))
  })
  
  # Output the number of results
  output$result_count <- renderText({
    paste("Number of results:", nrow(filtered_data()))
  })
  
  # Output the plot
  output$plot <- renderPlot({
    ggplot(filtered_data(), aes(x = year, y = lifeExp, color = continent)) +
      geom_line() +
      labs(title = "Life Expectancy Over Time",
           x = "Year",
           y = "Life Expectancy") +
      theme_minimal()
  })
}

# Run the app
shinyApp(ui = ui, server = server)
