# Load the libraries needed to run this app
library(shiny)
library(DT)
library(gapminder)
library(ggplot2)

# The first thing that I will do is define the ui 
ui <- fluidPage(
  titlePanel("Gapminder Data with Filters"),
  
  sidebarLayout(
    sidebarPanel(
      # I want to allow viewers to filter the data based on specific continents so I have included a panel on the side with filtering options based on the continents in the Gapminder dataset
      # I have also included a slider that allows viewers to also filter the dataset based on what years they are interested in exploring
      # Lastly, there is a code that displays the number of entries when filtering based on years
      # These features are useful and relevant as they will help viewers easily filter the information that is most interesting to them. Additionally, these features are relevant because filtering by continent and year are two aspects that are likely of interest to viewers when looking at this dataset
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
      # I want to create multiple tabs to display the Table, Plot, and Picture of a world map
      # The tabs feature is important and relevant because it helps organize my app in a cleanly and visually appealing manner
      # The Table is necessary so that viewers can see all variables in the dataset 
      # The Plot helps to visualize the life expectancy over the years based on continent which is relevant and useful information to know about this dataset
      # The image of the world is also important because it helps viewers visualize what the different coninents are. It is logical to show this map as the different filtering options in the slider are only for continents 

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
