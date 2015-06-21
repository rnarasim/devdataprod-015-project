library(shiny)
library(ggplot2)
library(dplyr)
library(lubridate)
library(reshape2)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
       
 
        ## this is plotting batch savings by Week Day in Hours
        output$BatchSummaryByDayPlot <- renderPlot({
                
                # add Day of the Week and BusinessDate along with filtering the data
                # by project (this comes fromt he input )
                stats_summary <- raw_stats %>% mutate( DayOfTheWeek = weekdays(ymd(BusinessDate)), BusinessDay = wday(ymd(BusinessDate)) ) %>% filter (Project == input$Project) %>% group_by(Event, BusinessDay, DayOfTheWeek) %>% summarize(AverageExecutionTime=sum(ExecutionTime)/(n_distinct(BusinessDate)*60*60))
                
                # data is converted to compact format for calculating batch savings.
                stats_summary_compact <- dcast(stats_summary ,DayOfTheWeek+BusinessDay ~ Event, value.var="AverageExecutionTime")
                
                stats_summary_compact$BatchSavings <- stats_summary_compact$PreMigration - stats_summary_compact$PostMigration
                
                # data is teared down into long format for ggplot to be happy.
                stats_summary_long <- melt (stats_summary_compact, id.var=c("BusinessDay", "DayOfTheWeek"))
        
                ggplot(stats_summary_long, aes(x=BusinessDay,y=value ,fill=variable )) + geom_bar(stat="identity", position="dodge") + xlab("Week Day")+ ylab("Average Total Execution Time (Hours)") + ggtitle( paste("Batch Savings (Hours) Realised by WeekDay for Project: ", input$Project, sep=" "))  + scale_x_discrete(breaks= unique(stats_summary$BusinessDay), label= unique(stats_summary$DayOfTheWeek)) +scale_fill_discrete (name="Event") + coord_cartesian(xlim = c(0,8))
        })
        
        # Create a table that lists the average run time of job(minutes) Pre Migration 
        # and post migration and also batch savings.
        output$BatchSummaryByJob <- renderDataTable({
                
                # filter the data by project( this comes from the input selection) and is grouped by Project
                stats_summary_by_job <- raw_stats  %>% filter (Project == input$Project) %>% group_by(JobName, Event) %>% summarize(AverageExecutionTime=mean(ExecutionTime)/(60))
                
                # converted to compact format for calculating batch savings
                stats_summary_by_job_compact <- dcast(stats_summary_by_job, JobName ~ Event, value.var = "AverageExecutionTime")
                
                stats_summary_by_job_compact$BatchSavings <- stats_summary_by_job_compact$PreMigration - stats_summary_by_job_compact$PostMigration
                
                # this table is dumped to the browser for app users to review.
                stats_summary_by_job_compact
                
                
        })

})