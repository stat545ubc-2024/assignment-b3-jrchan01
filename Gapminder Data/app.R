# Load the libraries needed to run this app
library(shiny)
library(DT)
library(gapminder)
library(ggplot2)
library(plotly)  # This helps to create interactive plots
library(dplyr)   # This helps with data manipulation

# My first new addition is to use CSS to add different colours and themes to the app
# This is useful because it makes the app more digestable for viewers thus improving the overall quality of the app.
custom_theme <- "
body {
  background-color: #f5f5f5;  /* Light gray background */
  color: #333333;             /* Dark gray text */
}
.sidebarPanel {
  background-color: #ffffff;  /* White sidebar background */
}
.panel-body {
  background-color: #ffffff;  /* White main panel background */
}
h4, .tab-title {
  color: #444444;             /* Darker gray for headers */
}
.tab-content {
  background-color: #ffffff;  /* White tab content background */
}
"

# Define the UI
ui <- fluidPage(
  tags$head(
    tags$style(HTML(custom_theme))
  ),
  
  titlePanel("Gapminder Data with Filters"),
  # I want to allow viewers to filter the data based on specific continents so I have included a panel on the side with filtering options based on the continents in the Gapminder dataset
  # I have also included a slider that allows viewers to also filter the dataset based on what years they are interested in exploring
  # Lastly, there is a code that displays the number of entries when filtering based on years
  # These features are useful and relevant as they will help viewers easily filter the information that is most interesting to them. Additionally, these features are relevant because filtering by continent and year are two aspects that are likely of interest to viewers when looking at this dataset
  sidebarLayout(
    sidebarPanel(
      selectInput("continent", "Select Continent(s):",
                  choices = unique(gapminder$continent), selected = unique(gapminder$continent),
                  multiple = TRUE),
      
      sliderInput("year", "Select Year Range:",
                  min = min(gapminder$year), max = max(gapminder$year),
                  value = range(gapminder$year)),
      
      
      numericInput("top_n", "Select Top N Countries by Population:",
                   value = 5, min = 1, max = 20),
      
      # Display the number of results
      textOutput("result_count"),
      
      h4("Summary Statistics"),
      textOutput("avg_lifeExp"),
      textOutput("total_population")
    ),
    # I want to create multiple tabs to display the Table, Plot, and Picture of a world map
    # The tabs feature is important and relevant because it helps organize my app in a cleanly and visually appealing manner
    # Another new feature I am adding is a summary statistics tab. This allows viewers to see the average life expectancy, the total population, and the GDP per capita based on continents. The code for this new tab can be seen near the bottom.
    # The Table is necessary so that viewers can see all variables in the dataset 
    # The Plot helps to visualize the life expectancy over the years based on continent which is relevant and useful information to know about this dataset
    # The image of the world is also important because it helps viewers visualize what the different coninents are. It is logical to show this map as the different filtering options in the slider are only for continents 
    # The summary statistics feature is useful and improves the quality of the app because it is a simple tab that breaks down general statistics for viewers to see. This is important because then they do not need to worry about manually calculating these totals based on the filters they are interested in. 
    
    mainPanel(
      tabsetPanel(
        tabPanel("Table", DTOutput("table")),
        
        tabPanel("Plot", plotlyOutput("plot")),
        
        tabPanel("World Map", 
                 img(src = "world_map.png", 
                     alt = "World Map with Continents", 
                     width = "100%")),
        
        tabPanel("Statistics Summary", tableOutput("summary_table"))
      )
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  # Reactive expression to filter data by continent and year, and then calculate summary statistics
  filtered_data <- reactive({
    data <- gapminder %>% 
      filter(continent %in% input$continent,
             year >= input$year[1] & year <= input$year[2]) %>%
      group_by(continent, year) %>%
      summarize(
        avg_lifeExp = mean(lifeExp, na.rm = TRUE),
        avg_gdpPercap = mean(gdpPercap, na.rm = TRUE),
        total_pop = sum(pop, na.rm = TRUE)
      ) %>%
      ungroup()
    data
  })
  
  # I have added a new feature that allows viewers to select the top 'n' countries based on population
  # This is useful and improves the quality of the app because it allows viewers to specify what data they want to see depending on top country populations
  output$table <- renderDT({
    data_table <- gapminder %>%
      filter(continent %in% input$continent,
             year >= input$year[1] & year <= input$year[2]) %>%
      arrange(desc(pop)) %>%
      group_by(year) %>%
      top_n(input$top_n, pop) %>%
      ungroup()
    datatable(data_table, filter = 'top', options = list(pageLength = 10))
  })
  
  # Output the number of results
  output$result_count <- renderText({
    paste("Number of results:", nrow(filtered_data()))
  })
  
  # Another new feature I have added is creating an interactive plot for viewers.
  # This improves the quality of the app because it allows users to scroll over the graph to view specific quantities. 
  output$plot <- renderPlotly({
    p <- ggplot(filtered_data(), aes(x = year, y = avg_lifeExp, color = continent)) +
      geom_line(size = 1.2) +
      labs(title = "Average Life Expectancy Over Time by Continent",
           x = "Year",
           y = "Average Life Expectancy") +
      scale_color_manual(values = c("#7289DA", "#99AAB5", "#FF73FA", "#43B581", "#F04747")) +  # Accent colors for continents
      theme_minimal() +
      theme(
        plot.background = element_rect(fill = "#f5f5f5", color = NA),  # Matches background
        panel.background = element_rect(fill = "#ffffff", color = NA), # White panel background
        text = element_text(color = "#333333"),                        # Dark gray text
        axis.title = element_text(color = "#666666"),                  # Medium gray axis labels
        axis.text = element_text(color = "#666666"),                   # Medium gray axis text
        legend.title = element_text(color = "#444444"),                # Dark gray legend title
        legend.text = element_text(color = "#333333")                  # Dark gray legend text
      )
    ggplotly(p)  # Convert ggplot to plotly for interactivity
  })
  
  # Output summary statistics
  output$avg_lifeExp <- renderText({
    avg_lifeExp <- mean(filtered_data()$avg_lifeExp, na.rm = TRUE)
    paste("Average Life Expectancy:", round(avg_lifeExp, 1))
  })
  
  output$total_population <- renderText({
    total_pop <- sum(filtered_data()$total_pop, na.rm = TRUE)
    paste("Total Population:", format(total_pop, big.mark = ","))
  })
  
  # Output Statistics Summary table with GDP per capita
  output$summary_table <- renderTable({
    summary_data <- filtered_data() %>%
      group_by(continent) %>%
      summarize(
        Avg_Life_Expectancy = round(mean(avg_lifeExp, na.rm = TRUE), 1),
        Avg_GDP_per_Capita = round(mean(avg_gdpPercap, na.rm = TRUE), 1),
        Total_Population = format(sum(total_pop, na.rm = TRUE), big.mark = ",")
      )
    summary_data
  })
}

# Run the app
shinyApp(ui = ui, server = server)
