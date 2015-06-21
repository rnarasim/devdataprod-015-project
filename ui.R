library(shiny)
library(BH)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
        
        # Application title
        titlePanel("ETL Upgrade Project Performance"),
     
        
        sidebarLayout(
                
                sidebarPanel(
                       # Select Project Name as Input
                        selectInput("Project", label = h3("Project Name:"), 
                                    as.list(unique(raw_stats$Project)))
                
                ),
                
          
                mainPanel(
                        tabsetPanel(id="tabSets",
                                    
                        # ggplot showing Batch Savings By Day
                        tabPanel("Batch Summary By Day Plot", plotOutput("BatchSummaryByDayPlot")),
                        
                        # Table of Batch Performance By Job that could be sorted
                        tabPanel("Batch Summary By Job", dataTableOutput("BatchSummaryByJob")),
                        
                        # Help/Documentation 
                        tabPanel("Help/Documentation", includeMarkdown("ETLUpgradeProjectPerformance.Rmd"))
                        
                        )
                )
        )
))
