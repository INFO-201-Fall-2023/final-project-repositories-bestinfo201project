
source("Data Frame Test Sheet.R")

vaccine_list <- list(
  "All" = "All",
  "Total" = "Total.doses.administered.by.jurisdiction",
  "Pfizer" = "Total.number.of.original.Pfizer.doses.administered",
  "Moderna" = "Total.number.of.original.Moderna.doses.administered",
  "Janssen" = "Total.number.of.Janssen.doses.administered",
  "Novavax" = "Total.number.of.Novavax.doses.administered",
  "Other" = "Total.number.of.doses.from.other.manufacturer.administered"
)

ui <- fluidPage(tabsetPanel(tabPanel(
  "Intro",titlePanel(title = "Introduction"),
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
  imageOutput("covid_png")
  ),
  tabPanel(
  "An Initial Look at Vaccines and Income",
  titlePanel("The affect of total income on Vaccine Rates"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "vaccine_name",
        label = "Choose Vaccine",
        choices = vaccine_list,
        selected = NULL
      ),
      br(),
      HTML("Here we can see a strong correlation between the total income and 
           the total vaccine doses administered accross all different types of vaccines.
           Larger states of course have a higher amount of vaccines administered and total income,
           we can see how the less commonly taken vaccines have a bit more variance but still 
           clearly follow an upwards trend.")
    ),
    mainPanel(h3("Vaccine plots"),
              plotlyOutput(outputId = "scatter"))
  )),
  tabPanel(
  "Accounting for the individual",
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "vaccine_name_income",
        label = "Choose Vaccine",
        choices = vaccine_list,
        selected = NULL
      ),
      HTML("The plot shows much less correlation when accounting for individual income.
           Here we can see little to no influence on the affect of average individual state income
           on the total vaccine administered across all different types.")
    ),
    mainPanel(h3("Income Normalized Vaccine Plot"),
            plotlyOutput(outputId = "scatter_income"))
  )),
  tabPanel(
    "Correlation Matrix",
      HTML("Let's drill down into which factors influence each other, talk about some of the interesting relations"),
      h3("Correlation Plot"),
      plotlyOutput("correlation_plot")
    )),
  tabPanel(
    "Tab 4",
    sidebarLayout(
      sidebarPanel(
        selectInput(
          inputId = "vaccine_name_normal",
          label = "Choose Vaccine",
          choices = vaccine_list,
          selected = NULL
        )
      ),
      mainPanel(h3("Fully Normalized Vaccine Plot"),
                plotlyOutput(outputId = "scatter_normal"))
  )
  )
))


server <- function(input, output) {
  output$scatter <- renderPlotly({
    return(get_vaccine_plot(input$vaccine_name))
  })
  output$scatter_income <- renderPlotly({
    return(get_vaccine_plot(input$vaccine_name_income, normalize_income = TRUE, fit_line = FALSE))
  })
  output$scatter_normal <- renderPlotly({
    return(get_vaccine_plot(input$vaccine_name_normal, normalize_income = TRUE, normalize_vaccine = TRUE, fit_line = TRUE))
  })
  output$correlation_plot <- renderPlotly({
    return(ggplotly(heat_plot))
  })
  output$covid_png <- renderImage({
    filename <- file.path(getwd(), "covid.png")
    print(filename)
    list(src = filename, alt = "Image")
  }, deleteFile = FALSE)
}

# Run the application
shinyApp(ui, server)