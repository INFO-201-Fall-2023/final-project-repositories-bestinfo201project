library(dplyr)
library(stringr)
library(ggplot2)
library(shiny)
library(plotly)


ui <- fluidPage(
  titlePanel(title = "Introduction"),
  br(),
  h1("Why Analyze COVID-19 Vaccination Rates and Income?"),
  p("The development and distribution COVID-19 vaccines has been a vital part of our global response to the COVID-19 pandemic. As 
  various versions of vaccines have become available, there have been clear disparities in what groups have easy access to them. 
  We investigated prominent health disparities that were highlighted by the COVID-19 pandemic in hopes of seeing how prevalent rates of economic disparities are in the U.S. 
  These disparities have been most prominent due to disproportionately higher infection and death rates in most marginalized populations. 
  Our analysis of the factors influencing vaccination rate help show the trends in vaccination and income rates that we elaborate on throughout this website."),
  br(),
  tags$h1("Data Information"),
  "To source the data we used for our analysis, we pulled vaccination rates from the ",
  tags$a(href="https://covid.cdc.gov/covid-data-tracker/#vaccinations_vacc-people-booster-percent-pop5", 
         "CDC's COVID-19 vaccination datasource for each state."),
  "To source individual and state income rates, we used the ",
  tags$a(href="https://apps.bea.gov/regional/downloadzip.cfm",
          "BEA's income datasource for each state."),
  
)

server <- function(input, output, session) {
}
shinyApp(ui, server)
  