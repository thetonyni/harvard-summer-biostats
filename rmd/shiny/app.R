library(shiny)
library(tidyverse)
library(mdsr) 
library(fivethirtyeight)
library(colourpicker)
library(shinythemes)

#WIP NOT FINISHED (on hold??? might not be useful)

#Data Wrangling

setwd("~/harvard-summer-biostats/data")

illinois <- read_csv("illinois.csv") #read in data

illinois1 <- illinois %>%
  select(site, disposal.area, type, well.id, gradient, contaminant, 
         measurement.unit, concentration) %>%
  mutate(well.id_contaminant = paste0(well.id, "_", contaminant)) %>% #for future use
  rename(c("disposal_area" = "disposal.area", "well_id" = "well.id",
           "unit" = "measurement.unit"))

#fixing 'contaminant' string by removing everything after the comma
illinois1$contaminant=gsub(", total", "", illinois1$contaminant)

#testing
avg_contaminant <- illinois1 %>%
  group_by(well_id, contaminant) %>% 
  summarise_each(funs(mean)) %>%
  select(1,2,8) #selecting only numeric columns

#temporarily uniting columns for joining in next step
temp <- avg_contaminant %>%
  unite("well.id_contaminant", well_id, contaminant)

#joining orig dataframe and avg_contaminant dataframe
combined <- left_join(temp, illinois1, by = "well.id_contaminant") %>%
  distinct(well.id_contaminant, .keep_all = TRUE) %>%
  separate(well.id_contaminant, c('well_id', 'contaminant'), sep="_") %>%
  select(1:8)

#spreading to wide data frame format to add missing info
combined2 <- combined %>% #collapse empty rows
  spread(contaminant, concentration.x) %>%
  group_by(well_id) %>%
  summarise_each(funs(first(.[!is.na(.)]))) %>%
  select(-c(unit))

#gathering back to long data frame format
combined3 <- combined2 %>%
  gather("contaminant", "concentration", 6:26)


#Defining vectors for choices 
testing <- levels(as.factor(combined3$well_id))

#Define UI for an application to draw plots

ui <- fluidPage(theme = shinytheme("sandstone"),
                selectInput(inputId = "inputobject1",
                            label = "Make a choice",
                            choices = testing),

                mainPanel(
                  tabsetPanel(type = "tabs",
                              tabPanel("Histogram", value = 1, plotOutput(outputId = "histplot")),
                              id = "tabselected"
                  )
                )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$histplot <- renderPlot({
    ggplot(data = combined3 %>%
             filter(well_id == "03R"), aes(x = contaminant, y = concentration,
                                           fill = contaminant)) + 
      geom_bar(stat = "identity", show.legend = FALSE) + 
      xlab("Contaminant") +
      ylab("Concentration") +
      ggtitle("Concentration of Contaminants in Well 03R") +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
  })
}


# Run the application 
shinyApp(ui = ui, server = server)
