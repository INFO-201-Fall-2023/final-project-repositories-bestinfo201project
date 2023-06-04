library(stringr)
library(ggplot2)
library(tidyr)
library(reshape2)
library(dplyr)
library(plotly)


initial_income_rate_df <-
  read.csv("SQINC1__ALL_AREAS_1948_2022_CLEAN.csv")
initial_vaccine_rates_df <-
  read.csv("covid19_vaccinations_in_the_united_states_CLEAN.csv")

income_rate_df <- initial_income_rate_df
vaccine_rates_df <- initial_vaccine_rates_df

income_rate_df <-
  mutate(income_rate_df, GeoName = str_replace(GeoName, " \\*", ""))

vaccine_rates_df <-
  mutate(
    vaccine_rates_df,
    Jurisdiction..State.Territory..or.Federal.Entity
    = str_replace(
      Jurisdiction..State.Territory..or.Federal.Entity,
      "New York State",
      "New York"
    )
  )
income_rate_df <- select(income_rate_df,-IndustryClassification)

# Remove the columns that are of income from before 2010 and put them in a seperate df to be processed later
column_pattern <- "X(19[4-9][0-9]|200[0-9]).Q[1-4]"
selected_columns <-
  str_subset(colnames(income_rate_df), column_pattern)

# Store the income columns in a seperate df to be used later
pre2010_income <-
  income_rate_df[income_rate_df$Description == "Personal income (millions of dollars, seasonally adjusted) ", colnames(income_rate_df) %in% selected_columns]


# Remove unnecessary information
income_rate_df <-
  select(income_rate_df,-Description,-TableName,-Unit,-LineCode)
income_rate_df <-
  income_rate_df[,!(colnames(income_rate_df) %in% selected_columns)]

# Split the income data into the three separate categories income, population, and GDP
state_income <- income_rate_df[seq(1, nrow(income_rate_df), 3), ]
state_population <- income_rate_df[seq(2, nrow(income_rate_df), 3), ]
state_GDP <- income_rate_df[seq(3, nrow(income_rate_df), 3), ]

# Remerge the data so the rows are converted to columns
state_merge <-
  inner_join(
    state_income,
    state_population,
    by = join_by(GeoName == GeoName, GeoFIPS == GeoFIPS, Region == Region),
    suffix = c(".income", ".population")
  )
state_merge <-
  inner_join(
    state_merge,
    state_GDP,
    by = join_by(GeoName == GeoName, GeoFIPS == GeoFIPS, Region == Region),
    suffix = c("", ".GDP")
  )

# Merge the vaccine and new state data frame
merged <- inner_join(
  state_merge,
  vaccine_rates_df,
  by =  join_by(
    "GeoName" == "Jurisdiction..State.Territory..or.Federal.Entity"
  )
)


# Categorical: create a column that stores the states with herd immunity (vaccine percentage over 80 percent)
merged <-
  mutate(merged, Herd.immunity = Percent.of.total.pop.with.at.least.one.dose > 80)

# Continuous: create a column that measures the 2022 income against the percent of population with at least one dose
merged <-
  mutate(merged, Income.per.dose = X2022.Q4.income / Residents.with.at.least.one.dose)

vaccine_col_names <-
  c(
    "Total.doses.administered.by.jurisdiction",
    "Total.number.of.original.Pfizer.doses.administered",
    "Total.number.of.original.Moderna.doses.administered",
    "Total.number.of.Janssen.doses.administered",
    "Total.number.of.Novavax.doses.administered",
    "Total.number.of.doses.from.other.manufacturer.administered"
  )

# Categorical: assign the most common vaccine dose per state
vaccines <- c("Pfizer", "Moderna", "Jansen", "Noravax", "other")
vaccine_administered_columns <-
  select(merged, all_of(vaccine_col_names))
common_vaccine_index <-
  apply(vaccine_administered_columns, 1, which.max)
common_vaccine_name <- vaccines[common_vaccine_index]
merged <- mutate(merged, Most.common.vaccine = common_vaccine_name)

# Continuous: Take the increase in percentage income over the last 10 years
merged <-
  mutate(merged, income_percent_increase10 = X2012.Q1.income / X2022.Q4.income * 100)

# Continuous: Take the percent increase in income against the doses administered
merged <-
  mutate(merged,
         increase_over_vaccines_administered = income_percent_increase10 / Residents.with.at.least.one.dose)

# Change the vaccines to by numeric instead of strings
merged <-
  mutate_at(merged, vars(all_of(vaccine_col_names), X2022.Q4.population, Doses.distributed.per.100K.pop, Doses.administered.by.jurisdiction.per.100K.pop, Total.doses.administered.by.jurisdiction, Total.doses.distributed), as.numeric)

#Seperate the US as a whole into a seperate data set
merged_US <- merged
merged <- filter(merged, GeoName != "United States")

# Summary: Add the data set that groups states by geographical region and take total doses
# administered in that region, total population in that region, average income for the region and
# average change in income over the past 10 years
US_regions <- read.csv("USAregions.csv")
merged <-
  left_join(merged, US_regions, by = join_by(GeoName == Name))
regional_group <- group_by(merged, Region.Name)
regional_df <-
  summarise(
    regional_group,
    Income = sum(X2022.Q4.income),
    Population = sum(X2022.Q4.population),
    Doses.distributed = sum(Total.doses.distributed),
    Residents.with.at.least.one.dose = sum(Residents.with.at.least.one.dose),
  )

# Vaccine rate vs income normalized for population
plot <-
  ggplot(
    merged,
    aes(y = Percent.of.total.pop.with.at.least.one.dose, x = X2022.Q4, label = GeoName)
  ) +
  geom_point() +
  geom_text(aes(
    label = GeoName,
    hjust = -0.1,
    vjust = -0.3
  ))

# Write the data to a csv file if necessary
# write.csv(merged, "Vaccine_Income_Comparison.csv")



# Scatter plots of some of the more interesting relations
scatter_income_increase <-
  ggplot(
    data = filter(merged, GeoName != "United States"),
    aes(y = Doses.administered.by.jurisdiction.per.100K.pop, x = income_percent_increase10)
  ) +
  geom_point()

scatter_income_current <-
  ggplot(
    data = filter(merged, GeoName != "United States"),
    aes(y = Doses.administered.by.jurisdiction.per.100K.pop, x = X2022.Q4)
  ) +
  geom_point(aes(size = X2022.Q4.population)) +
  labs(x = "Income per Capita", y = "Doses Administered per 100K", size = "Population") +
  geom_smooth(method = "lm", se = TRUE)

correlation_data <-
  select(
    merged,
    "2022 Average Income per Person" = X2022.Q4,
    "Doses Administered per 100K" = Doses.administered.by.jurisdiction.per.100K.pop,
    "Doses Distributed sper 100K" = Doses.distributed.per.100K.pop,
    "2022 Population" = X2022.Q4.population,
    "Total Doses Administered" = Total.doses.administered.by.jurisdiction,
    "Total Income" = X2022.Q4.income,
    "Doses Distributed" = Total.doses.distributed,
    "Percent Increase in Total Income" = income_percent_increase10
  )
# pair_plot <- pairs(correlation_data)
df_long <- correlation_data %>%
  tidyr::gather(key = "Variable", value = "Value")

# Create scatter plot matrix using ggplot2
gg <- ggplot(df_long, aes(x = Value, y = Column, color = Variable)) +
  geom_point() +
  facet_grid(X ~ Variable, scales = "free") +
  theme_minimal()

income_over_time <- read.csv("Income_Over_Time.csv")
income_over_time <- select(income_over_time, c(1:3))
income_over_time <-
  left_join(
    income_over_time,
    select(merged, GeoName, Total.doses.administered.by.jurisdiction),
    by = join_by(State == GeoName)
  )

line_plot <-
  ggplot(data = income_over_time, aes(x = Year, y = Average.Income, group = State)) +
  geom_line(aes(color = Total.doses.administered.by.jurisdiction)) 


# Makes a plot for vaccine vs income based on a few parameters
get_vaccine_plot <- function(vaccine_input, normalize_vaccine = FALSE, normalize_income = FALSE, fit_line = TRUE){
  if (vaccine_input == "All") {
    vaccine_df <-
      gather(merged,
             key = "Column",
             value = "Value",
             all_of(vaccine_col_names))
    vaccine_df$Column <- gsub("\\.", " ", vaccine_df$Column)
    p = NULL
    if(normalize_income & normalize_vaccine){
      p <- ggplot(vaccine_df,
                  aes(
                    x = Value / X2022.Q4.population,
                    y = X2022.Q4,
                    alpha = 0.4
                  ))
    }else if(normalize_vaccine){
      p <- ggplot(vaccine_df,
                  aes(
                    x = Value / X2022.Q4.population,
                    y = X2022.Q4.income,
                    alpha = 0.4
                  ))
    }else if(normalize_income){
      p <- ggplot(vaccine_df,
                  aes(
                    x = Value,
                    y = X2022.Q4,
                    alpha = 0.4
                  ))
    }else{
      p <- ggplot(vaccine_df,
                  aes(
                    x = Value,
                    y = X2022.Q4.income,
                    alpha = 0.4
                  ))
    }
    
    p = p +
      geom_point(aes(col = Column, size = X2022.Q4.population)) +
      scale_color_manual(
        values = c("black", "blue", "violet", "purple", "lightblue", "magenta")
        # labels = names(vaccine_list)
      ) +
      labs(x = "Total Vaccine Doses", y = "Income", col = "Vaccine Type") 
    # scale_x_continuous(limits = c(0, 5e7), breaks = seq(0, 5e7, by = 5e6)) +
    # scale_y_continuous(limits = c(4e4, 1e5), breaks = seq(4e4, 1e5, by = 1e4))
    if(fit_line){
      p = p + geom_smooth(method = "lm", se = FALSE, aes(group = Column), size = 0.8, color = "lightblue3", alpha = 0.5)
    } 
    # Case where only one vaccine is selected
  } else{
    p = NULL
    if(normalize_income & normalize_vaccine){
      p <- ggplot(merged,
                  aes(
                    x = pull(select(merged, vaccine_input)) / X2022.Q4.population,
                    y = X2022.Q4,
                    alpha = 0.4
                  ))
    }else if(normalize_vaccine){
      p <- ggplot(merged,
                  aes(
                    x = pull(select(merged, vaccine_input)) / X2022.Q4.population,
                    y = X2022.Q4.income,
                    alpha = 0.4
                  ))
    }else if(normalize_income){
      p <- ggplot(merged,
                  aes(
                    x = pull(select(merged, vaccine_input)),
                    y = X2022.Q4,
                    alpha = 0.4
                  ))
    }else{
      p <- ggplot(merged,
                  aes(
                    x = pull(select(merged, vaccine_input)),
                    y = X2022.Q4.income,
                    alpha = 0.4
                  ))
    }
    p <-
      p +
      geom_point() +
      labs(x = "Total Vaccine Doses", y = "Income")
    if(fit_line){
      p = p + geom_smooth(method = "lm", se = FALSE, size = 0.8, color = "lightblue3", alpha = 0.5)
    } 
  }
  p <- ggplotly(p)
  return(p)
  
}


