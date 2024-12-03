# Gapminder Data App

## Link to App
https://jrchan01.shinyapps.io/GapminderV2/

## Description of App
This app allows viewers to explore a table associated with the Gapminder dataset (see below for more information), an example plot, and an image of the world map. Additionally, viewers can use a filter function to visualize data about specific continents that interest them and specify what years they want included. A new feature included is adding colour using CSS. 

### The table
In the app, the table shows all the variables associated with the gap minder dataset. At the top, viewers see the six variables (country, continent, year, life expectancy, population, and GDP per capita). Each variable can be organized from lowest value to highest value or vice versa by pushing the desired arrow listed next to the variable of interest. Viewers can also search for specific entries in the search bar and use a toggle to choose how many rows appear (e.g., 10, 25, 50, or 100). Lastly, little boxes below each variable allow viewers to filter based on what item they want to view in that column. This is relevant because if viewers are interested in exploring the gapminder dataset, knowing what the variables are and having the ability to arrange them in certain ascending or descending orders will enable them to view what they want quickly. This also displays the data in a more digestible manner.

### The plot
This plot shows viewers the life expectancy from 1952 to 2007 based on continent. Each continent is represented by a different-coloured line. For example, the red line shows the life expectancy in Africa from 1952 to 2007. This is important and relevant to include in the app because it is one example of how the data can be displayed. The plot of life expectancy over time is logical because users viewing the gapminder dataset are likely interested in how life expectancy has changed over time. This plot not only shows how life expectancy changes over time, it also filters everything by continent. A new addition is that the plot is interactive, allowing viewers to move their cursor over the graph to look at specific values. 

### The world map
This tab displays an image of the world map with different continents labelled. This is relevant for the app because one of the filter options available is to choose specific continents. For viewers who are not as knowledgeable about the continents and where they are located, this image will be a visual aid. The photo used is stored in the www folder. 

### Summary Statistics
This additional tab allows viewers to look at some summary statistics of the data in the Gapminder dataset. This tab automatically calculates the summary statistics based on the filters that viewers choose. This is useful because they will be able to easily view different summaries without having to manually compute them.  

### Filtering
In addition to the table, plot, and world map, viewers can also filter the dataset so that a specific continent or range of years appear. On the left hand side of the page there is a box with a toggle to enable viewers to specify what continents they want to see. Additionally, below there is a slider that can be used to indicate what range of years are shown. The bolded number beneath tells viewers how many total entries there are based on the filters they use. This is a useful feature to include in the app because it allows viewers to simplify the dataset so that they are only seeing what is of interest to them. Additionally, there is also a function that enables viewers to select the top ‘n’ countries based on population. This allows them to further simplify and filter what data they are interested in viewing. 

## Information about the dataset used
In this app, viewers will be able to explore the Gapminder dataset. This dataset comes from an independent Swedish foundation. This foundation created this dataset that is available for the public to use. The Gapminder dataset has statistics about life expectancy, population, and GDP per capita based on the year (ranging from 1952 to 2007), a specific continent, or a particular country. Users can view this dataset by installing the gapminder package in R Studio and running library(gapminder). 


