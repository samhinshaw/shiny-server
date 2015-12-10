library(shiny)
library(ggplot2)
library(dplyr)
library(scales)
library(httr)
# bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)
bcl <- read.csv("http://pub.data.gov.bc.ca/datasets/176284/BC_Liquor_Store_Product_Price_List.csv",stringsAsFactors = FALSE)
products <- c("BEER", "REFRESHMENT BEVERAGE", "SPIRITS", "WINE")
bcl <- dplyr::filter(bcl, PRODUCT_CLASS_NAME %in% products) %>%
	dplyr::select(-PRODUCT_TYPE_NAME, -PRODUCT_SKU_NO, -PRODUCT_BASE_UPC_NO,
								-PRODUCT_SUB_CLASS_NAME) %>%
	rename(Type = PRODUCT_CLASS_NAME,
				 Subtype = PRODUCT_MINOR_CLASS_NAME,
				 Name = PRODUCT_LONG_NAME,
				 Country = PRODUCT_COUNTRY_ORIGIN_NAME,
				 Alcohol_Content = PRODUCT_ALCOHOL_PERCENT,
				 Price = CURRENT_DISPLAY_PRICE,
				 Sweetness = SWEETNESS_CODE,
				 Liters_Per_Unit = PRODUCT_LITRES_PER_CONTAINER,
				 Count = PRD_CONTAINER_PER_SELL_UNIT)
bcl$Type <- sub("^REFRESHMENT BEVERAGE$", "REFRESHMENT", bcl$Type)
function(input, output, session) {
	output$prettysweetplot <- renderPlot({
		checkrows <- lapply(input, FUN = nrow)
		if(0 %in% checkrows){
			return(NULL)
		}
		if(input$expensive == "No"){
			filtered <-
				bcl %>% 
				filter(Alcohol_Content >= input$alcoholInput[1],
							 Alcohol_Content <= input$alcoholInput[2],
							 Price >= input$priceInput2[1],
							 Price <= input$priceInput2[2],
							 Type == input$typeInput,
							 Country == input$countryInput)
		} else if(input$expensive == "Yes") {
			filtered <-
				bcl %>% 
				filter(Alcohol_Content >= input$alcoholInput[1],
							 Alcohol_Content <= input$alcoholInput[2],
							 Price >= input$priceInput[1],
							 Price <= input$priceInput[2],
							 Type == input$typeInput,
							 Country == input$countryInput)
		}
		tetrad <- c("BEER" = '#B260AF', "WINE" = '#1DADFF',"SPIRITS" = '#FFD844', "REFRESHMENT" = '#FF6715')
		ggplot(filtered, aes(Price, fill = Type)) +
			geom_histogram(color="black", binwidth = 1) +
			xlab("Price") +
			ylab("Frequency") +
			ggtitle("Frequency Distribution of Price") +
			scale_fill_manual(name = "Beverage Type", values = tetrad) +
			scale_x_continuous(labels = dollar)
		
	})
	output$results <- DT::renderDataTable({
		if(input$expensive == "No"){
			if(input$sortup == "Ascending"){
				filtered <-
					bcl %>% 
					arrange_(input$sortby) %>%
					filter(Alcohol_Content >= input$alcoholInput[1],
								 Alcohol_Content <= input$alcoholInput[2],
								 Price >= input$priceInput2[1],
								 Price <= input$priceInput2[2],
								 Type == input$typeInput,
								 Country == input$countryInput)
			}
			else if(input$sortup == "Descending"){
				filtered <-
					bcl %>% 
					arrange_(paste0(c('desc(', input$sortby, ')'))) %>%
					filter(Alcohol_Content >= input$alcoholInput[1],
								 Alcohol_Content <= input$alcoholInput[2],
								 Price >= input$priceInput2[1],
								 Price <= input$priceInput2[2],
								 Type == input$typeInput,
								 Country == input$countryInput)
			}
		} else if(input$expensive == "Yes"){
			if(input$sortup == "Ascending"){
				filtered <-
					bcl %>% 
					arrange_(input$sortby) %>%
					filter(Alcohol_Content >= input$alcoholInput[1],
								 Alcohol_Content <= input$alcoholInput[2],
								 Price >= input$priceInput[1],
								 Price <= input$priceInput[2],
								 Type == input$typeInput,
								 Country == input$countryInput)
			}
			else if(input$sortup == "Descending"){
				filtered <-
					bcl %>% 
					arrange_(paste0(c('desc(', input$sortby, ')'))) %>%
					filter(Alcohol_Content >= input$alcoholInput[1],
								 Alcohol_Content <= input$alcoholInput[2],
								 Price >= input$priceInput[1],
								 Price <= input$priceInput[2],
								 Type == input$typeInput,
								 Country == input$countryInput)
			}
		}
		filtered
	})
}
