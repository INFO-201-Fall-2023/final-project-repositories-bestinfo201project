library(dplyr)
library(stringr)

income_rate_df <- read.csv("SQINC1__ALL_AREAS_1948_2022_CLEAN.csv")
vaccine_rates_df <- read.csv("covid19_vaccinations_in_the_united_states_CLEAN.csv")

income_rate_df <- mutate(income_rate_df, GeoName = str_replace(GeoName, " \\*", ""))

vaccine_rates_df <- mutate(vaccine_rates_df, Jurisdiction..State.Territory..or.Federal.Entity
                           = str_replace(Jurisdiction..State.Territory..or.Federal.Entity, "New York State", "New York"))

merged <- inner_join(income_rate_df, vaccine_rates_df, 
           by =  join_by("GeoName" == "Jurisdiction..State.Territory..or.Federal.Entity"))

# Remove the columns that are of income from before 2010 and put them in a seperate df to be processed later
column_pattern <- "X(19[4-9][0-9]|200[0-9]).Q[1-4]"
selected_columns <- str_subset(colnames(merged), column_pattern)

pre2010_income <- merged[merged$Description == "Personal income (millions of dollars, seasonally adjusted) ", colnames(merged) %in% selected_columns]

merged <- merged[, !(colnames(merged) %in% selected_columns)]

# TODO Categorical: create a column that stores the states with herd immunity (vaccine percentage over 80 percent)

# TODO Continuous: create a column that measures the 2022 income against the percent of population with at least one dose

# TODO Categorical: assign the most common vaccine dose per state

# TODO Continuous: Take the increase in percentage income over the last 10 years

# TODO Summary: Add the data set that groups states by geographical region and take total doses 
# administered in that region, total population in that region, average income for the region and
# average change in income over the past 10 years


