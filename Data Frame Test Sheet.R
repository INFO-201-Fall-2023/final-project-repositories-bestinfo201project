library(dplyr)
library(stringr)

income_rate_df <- read.csv("SQINC1__ALL_AREAS_1948_2022_CLEAN.csv")
vaccine_rates_df <- read.csv("covid19_vaccinations_in_the_united_states_clean.csv")

income_rate_df <- mutate(income_rate_df, GeoName = str_replace(GeoName, " \\*", ""))

vaccine_rates_df <- mutate(vaccine_rates_df, Jurisdiction..State.Territory..or.Federal.Entity
                           = str_replace(Jurisdiction..State.Territory..or.Federal.Entity, "New York State", "New York"))


merged <- merge(income_rate_df, vaccine_rates_df, by.x = "GeoName",
      by.y = "Jurisdiction..State.Territory..or.Federal.Entity")

merged2 <- inner_join(income_rate_df, vaccine_rates_df, 
           by =  join_by("GeoName" == "Jurisdiction..State.Territory..or.Federal.Entity"))

  

print(select(anti_join(income_rate_df, merged, by = "GeoName"), GeoName))

print(select(anti_join(vaccine_rates_df, merged, 
                by =  join_by("Jurisdiction..State.Territory..or.Federal.Entity" == "GeoName"))), Jurisdiction..State.Territory..or.Federal.Entity)



