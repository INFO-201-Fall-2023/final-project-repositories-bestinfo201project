
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
  "Tab 1",
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
      HTML("Here we can see a strong correlation between the total income and the total vaccine doses administered accross all different types of vaccines")
    ),
    mainPanel(h3("Vaccine plots"),
              plotlyOutput(outputId = "scatter"))
  )),
  tabPanel(
  "Tab 2",
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "vaccine_name_income",
        label = "Choose Vaccine",
        choices = vaccine_list,
        selected = NULL
      ),
      HTML("The plot shows much less correlation when accounting for income")
    ),
    mainPanel(h3("Income Normalized Vaccine Plot"),
            plotlyOutput(outputId = "scatter_income"))
  )),
  tabPanel(
    "Tab 3",
    sidebarLayout(
      sidebarPanel(
        HTML("Let's drill down into which factors influence each other, talk about some of the interesting relations")
        ),
      mainPanel(h3("Correlation Plot"),
                plotlyOutput("correlation_plot"))
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
}

# Run the application
shinyApp(ui, server)