library(shiny)
library(readr)
library(ggplot2)
library(shinythemes)
mydata <- read_csv("PKcovid.csv")

ui <- fluidPage(
  theme = shinytheme("darkly"),
  tags$head(
    tags$style(HTML("
      h1 {
        color: lime;
      }
      h2 {
        color: lime;
        font-size: 14px;
      }
      #tabularFormCases td {
        color: red;
      }
    "))
  ),
  tags$h1("Probability Project"),
  sidebarLayout(
    sidebarPanel(width=12,
      selectInput("analysisType", "Select Analysis Type:",
                  choices = c("Summary",
                              "Probabilities","Graphs",
                              "Predictions"),
                  selected = "Summary of Cases"),
      conditionalPanel(
        condition = "input.analysisType == 'Predictions'",
        numericInput("newCase", "Case Values For Deaths Prediction:", value = 1000),
        numericInput("newCase1", "Cases Value FOr Recovery Prediction:", value = 1000)
      ),
      actionButton("runAnalysis", "Run Analysis")
    ),
    mainPanel(
      width = 39,
      verbatimTextOutput("analysisResult"),
      textOutput("txt"),
      verbatimTextOutput("regression_deaths"),
      verbatimTextOutput("regression_deaths_2"),
      plotOutput("predictionPlot"),
      plotOutput("plotResult"),
      plotOutput("plotR"),
      plotOutput("plotResult1"),
      plotOutput("plotResult2"),
      plotOutput("plotResult3"),
      plotOutput("plotResult4"),
      plotOutput("componentplot"),
      plotOutput("componentplot_cases"),
      plotOutput("componentplot_recovery")
     
    )
  )
)

server <- function(input, output) {
  output$txt <- renderText({})  # Clear the output initially
  
  observeEvent(input$runAnalysis, {
    output$txt <- renderText({})
    analysis <- switch(input$analysisType,
                       "Summary" = {
                         case_summary <- summary(mydata$Cases)
                         death_summary <- summary(mydata$Deaths)
                         case_summary <- summary(mydata$Cases)
                         recovery_summary <- summary(mydata$Recovered)
                         case_std <- sd(mydata$Cases)
                         death_std <- sd(mydata$Deaths)
                         recovery_std <- sd(mydata$Recovered)
                         var_cases <- var(mydata$Cases)
                         var_death <- var(mydata$Deaths)
                         var_recovery <- var(mydata$Recovered)
                         q_cases <- quantile(mydata$Cases)
                         q_death <- quantile(mydata$Deaths)
                         q_recovery <- quantile(mydata$Recovered)
                         case_ci <- confint(lm(mydata$Cases ~ 1))
                         death_ci <- confint(lm(mydata$Deaths ~ 1))
                         recovery_ci <- confint(lm(mydata$Recovered ~ 1))
                         output$plotResult <- renderPlot(NULL)
                         output$plotR <- renderPlot(NULL)
                         output$regression_deaths<-NULL
                         output$plotResult1 <- NULL
                         output$plotResult2 <- NULL
                         output$plotResult3 <- NULL
                         output$componentplot <- NULL
                         output$componentplot_cases <- NULL
                         output$componentplot_recovery <- NULL
                         output$predictionPlot<-NULL
                         list(
                           "Total Cases Summary" = case_summary,
                           "Standard Deviation of Cases" = case_std,
                           "Deaths Summary" = death_summary,
                           "Standard Deviation of Deaths" = death_std,
                           "Summary of Recovery" = recovery_summary,
                           "Standard Deviation of Recovery" = recovery_std,
                           "Variance of Cases" = var_cases,
                           "Variance of Deaths" = var_death,
                           "Variance of Recovery" = var_recovery,
                           "Quantile of Cases" = q_cases,
                           "Quantile of Deaths" = q_death,
                           "Quantile of Recovery" = q_recovery,"Confidence Intervals for Cases" = case_ci,
                           "Confidence Intervals for Deaths" = death_ci,
                           "Confidence Intervals for Recovery" = recovery_ci
                         )
                         
                         },
                       "Probabilities" = {
                         output$regression_deaths_2<-NULL
                         output$plotResult<-NULL
                         output$regression_deaths<-NULL
                         output$plotResult1 <- NULL
                         output$plotResult2 <- NULL
                         output$plotResult3 <- NULL
                         output$componentplot <- NULL
                         output$componentplot_cases <- NULL
                         output$componentplot_recovery <- NULL
                         output$regression_deaths<-NULL
                         output$predictionPlot<-NULL
                           # Calculate death probabilities for each province
                           total <- aggregate(mydata$Deaths ~ mydata$Province, data = mydata, sum)
                           total_cases <- aggregate(mydata$Cases ~ mydata$Province, data = mydata, sum)
                           death_rate <- (total$`mydata$Deaths`) / (total_cases$`mydata$Cases`) * 100
                           result <- data.frame(death_rate, Province = total$`mydata$Province`)
                           
                           # Calculate recovery probabilities for each province
                           r_total <- aggregate(mydata$Recovered ~ mydata$Province, data = mydata, sum)
                           r_total_cases <- aggregate(mydata$Cases ~ mydata$Province, data = mydata, sum)
                           recovery_rate <- (r_total$`mydata$Recovered`) / (r_total_cases$`mydata$Cases`) * 100
                           r_result <- data.frame(recovery_rate, Province = r_total$`mydata$Province`)
                           
                           # Create a list of the results
                           probabilities <- list(
                             "Probability of Death by Province" = result,
                             "Probability of Recovery by Province" = r_result
                           )
                           # Plot the bar chart
                           output$plotResult <- renderPlot({
                             barplot(death_rate, names.arg = total$`mydata$Province`,
                                     main = "Probabilities of Death by Province",
                                     xlab = "Province", ylab = "Probability (%)",col="red")
                           })
                           output$plotR <- renderPlot({
                             barplot(recovery_rate, names.arg = total$`mydata$Province`,
                                     main = "Probabilities of Recovery by Province",
                                     xlab = "Province", ylab = "Probability (%)",col="green")
                           })
                           probabilities
                         },
                       "Graphs"={
                         output$regression_deaths_2<-NULL
                         output$plotResult<-NULL
                         output$regression_deaths<-NULL
                         output$plotResult1 <- NULL
                         output$plotResult2 <- NULL
                         output$plotResult3 <- NULL
                         output$componentplot <- NULL
                         output$componentplot_cases <- NULL
                         output$componentplot_recovery <- NULL
                         output$regression_deaths<-NULL
                         output$predictionPlot<-NULL
                         output$plotResult1 <- renderPlot({
                           ggplot(mydata, aes(x = Province, y = Deaths)) +
                             geom_point() +
                             labs(x = "Province", y = "Total Deaths",
                                  title = "Scatter Plot of Total Deaths by Province") +
                             theme_bw()
                         }) 
                         output$plotResult2 <- renderPlot({
                           province=aggregate(mydata$Cases~mydata$Province,data=mydata,sum)
                           pie(province$`mydata$Cases`,label=province$`mydata$Province`,main="pie chart OF CASES IN EACH Province",col=rainbow(4))
                         }) 
                         output$plotResult3 <- renderPlot({
                           city=aggregate(mydata$Deaths~mydata$Province,data=mydata,sum)
                           pie(city$`mydata$Deaths`,label=city$`mydata$Province`,main="pie chart OF Death IN EACH Province",col=rainbow(4))
                         }) 
                         output$plotResult4 <- renderPlot({
                           city=aggregate(mydata$Recovered~mydata$Province,data=mydata,sum)
                           pie(city$`mydata$Recovered`,label=city$`mydata$Province`,main="pie chart OF Recovered IN EACH Province",col=rainbow(4))
                         }) 
                         output$componentplot <- renderPlot({
                           death_1=aggregate(mydata$Deaths~mydata$Province,data=mydata,sum)
                           label_1=c(death_1$`mydata$Province`)
                           barplot(death_1$`mydata$Deaths`,main="Component Bar Plot of deaths",col=rainbow(4),names.arg = label_1, las = 3,cex.names=0.6)
                         })
                         output$componentplot_cases <- renderPlot({
                           death_1=aggregate(mydata$Cases~mydata$Province,data=mydata,sum)
                           label_1=c(death_1$`mydata$Province`)
                           barplot(death_1$`mydata$Cases`,main="Component Bar Plot of cases",col=rainbow(4),names.arg = label_1, las = 3,cex.names=0.6)
                         })
                         output$componentplot_recovery <- renderPlot({
                           death_1 <- aggregate(mydata$Recovered ~ mydata$Province, data = mydata, sum)
                           label_1 <- as.character(unique(mydata$Province))
                           barplot(death_1$`mydata$Recovered`, main = "Component Bar Plot of Recovered", col = rainbow(length(label_1)), names.arg = label_1,las = 3,cex.names=0.6)
                           
                         })
                         output$pie<-renderPlot({
                           total_cases=c(sum(mydata$Cases),sum(mydata$Recovered),sum(mydata$Deaths))
                           lables_name=c("Total Cases","Total Recovered","Total Deaths")
                           pie(total_cases,label=lables_name,main="Corona Cases In Pakistan",col=rainbow(3))
                         })
                       },
                       "Predictions" = {
                         output$plotResult1 <- NULL
                         output$plotResult2 <- NULL
                         output$plotResult3 <- NULL
                         output$componentplot <- NULL
                         output$componentplot_cases <- NULL
                         output$componentplot_recovery <- NULL
                         
                         result <- lm(Deaths ~ Cases, data = mydata)
                         new_case <- input$newCase
                         predicted_deaths <- predict(result, newdata = data.frame(Cases = new_case))
                         output$regression_deaths <- renderPrint({
                           paste("Predicted number of deaths for Cases =", new_case, "is", round(predicted_deaths))
                         })
                         
                         output$predictionPlot <- renderPlot({
                           new_data <- data.frame(Cases = new_case, Deaths = predicted_deaths)
                           
                           ggplot() +
                             geom_point(data = mydata, aes(x = Cases, y = Deaths), color = "blue") +
                             geom_line(data = new_data, aes(x = Cases, y = Deaths), linetype = "dashed", color = "red") +
                             labs(x = "Cases", y = "Deaths", title = "Linear Regression Predictions") +
                             theme_bw()
                         })
                         
                         result1 <- lm(Recovered ~ Cases, data = mydata)
                         new_case1 <- input$newCase1
                         predicted_recovered <- predict(result1, newdata = data.frame(Cases = new_case1))
                         
                         output$regression_deaths_2 <- renderPrint({
                           paste("Predicted number of Recovered for Cases =", new_case1, "is", round(predicted_recovered))
                         })
                         
                         output$plotResult <- renderPlot({
                           new_data1 <- data.frame(Cases = new_case1, Recovered = predicted_recovered)
                           
                           ggplot() +
                             geom_point(data = mydata, aes(x = Cases, y = Recovered), color = "blue") +
                             geom_line(data = new_data1, aes(x = Cases, y = Recovered), linetype = "dashed", color = "red") +
                             labs(x = "Cases", y = "Recovered", title = "Linear Regression Predictions") +
                             theme_bw()
                         })
                       }
    )
    output$analysisResult <- renderPrint({
      analysis
    })
  })
}
shinyApp(ui, server)


