library(shiny)
library(ggplot2)
library(dplyr)
library(shinyjs)
bcl <- read.csv("http://pub.data.gov.bc.ca/datasets/176284/BC_Liquor_Store_Product_Price_List.csv",stringsAsFactors = FALSE)
# bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)
fluidPage(theme = "bootstrap.css",
					useShinyjs(),
					tags$head(tags$title("Liquor Store App")),
	titlePanel(img(src = "logo_bc_liquor_stores.png")),
	h4("\"Filter Yo\' Beverage!\""),
	sidebarLayout(
		sidebarPanel(
			sliderInput("alcoholInput", "Choose an Alcohol Content Range",
									min = 0, max = 100, value = c(0, 20), post = "%"),
			conditionalPanel(condition = "input.expensive == 'Yes'",
											 sliderInput("priceInput", "Choose a Price Range",
											 						min = 0, max = 2000, value = c(20, 40), pre = "$")),
			conditionalPanel(condition = "input.expensive == 'No'",
											 sliderInput("priceInput2", "Choose a Price Range",
											 						min = 0, max = 100, value = c(20, 40), pre = "$")),
			selectInput("expensive", "Allow Expensive Options?", choices = c("Yes", "No"), selected = "No"),
			checkboxGroupInput("typeInput", "Types of Beverages", 
												 choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"), 
												 selected = c("BEER", "REFRESHMENT", "SPIRITS", "WINE")), 
			checkboxGroupInput("countryInput", "Country",
									choices = c("CANADA", "FRANCE", "ITALY"), 
									selected = c("CANADA", "FRANCE", "ITALY")),
			h4(em(strong("Sort Table"), "(or use header)")),
			selectInput("sortby", "Sort By", choices = c("Price", "Alcohol_Content", "Sweetness"), selected = "Price"),
			selectInput("sortup", "Ascending or Descending?", choices = c("Ascending", "Descending"), selected = "Ascending")
		),
		mainPanel(
			plotOutput("prettysweetplot"), 
			br(), br(),
			DT::dataTableOutput("results"), 
			hr(),
			"CSS Theme \"Cosmo\" by", a("Thomas Park", href="http://github.com/thomaspark", target="_blank"), "at", a("bootswatch.com", href="http://bootswatch.com", target="_blank")
			
		)
	)
)
