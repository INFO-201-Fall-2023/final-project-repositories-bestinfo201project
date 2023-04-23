# COVID-19 and The Effect of Economic Disparity on Vaccination Rates

## Story Pitch

The development and distribution COVID-19 vaccines has been a vital part of our global response to the COVID-19 pandemic. As various versions of vaccines have become available, there have been clear disparities in what groups have easy access to them. These disparities have been revealed through disproportionately higher infection and death rates in most marginalized populations.  

We plan to develop an easily comprehensible analysis for income levels throughout various U.S. neighborhoods and COVID-19 vaccination rates for each area. This is since income level has been shown to influence healthcare quality and access throughout many generations, and the COVID-19 pandemic only exacerbated these differences. Since vaccination has been proven to be one of the best methods for preventing COVID-19, we believe that analyzing COVID-19 vaccination rates will be a good indicator for regional infection rates and other negative effects related to COVID-19 infection.  

Though this issue has been widely discussed throughout the past years, our background research showed that there are a lot of different factors that can be considered when operationalizing one’s socioeconomic class. Individual income, household income, and GDP per capita are all reasonable ways to quantify socioeconomic class that yield significantly different results. Ferreira (2021) found that when looking at GDP per capita, richer countries had higher COVID-19 mortality rates, despite having access to superior healthcare. However, Mitropoulos (2022) found that when looking at median household income, death rates of the lowest income group are double the death rates in the highest income group. While most past research has focused on death or infection rates, we hope that vaccination rates will be a good indicator of ease of access to the most basic component of healthcare: disease prevention. Examining vaccination statistics could reveal discrepancies in the accessibility of vaccine clinics or the availability of transportation to those clinics, and be used to pinpoint regions in which more funding is required to guarantee that everyone gets access to immunizations.  

Our analysis would help ensure that all communities are receiving the resources they need to stay healthy.  This is particularly important as we move forward into a post-pandemic world, where vaccine uptake will continue to play a critical role in reducing transmission and protecting individuals and communities.


## Finding Data

[Covid data by state](https://covid.cdc.gov/covid-data-tracker/#vaccinations_vacc-people-booster-percent-pop5)  
This data was collected by the CDC using a variety of techniques in order to get the most accurate and up to date information they used a multitude of data collecting technologies including:  
- **Vaccine Tracking System (VTrckS):** CDC’s vaccine order management system where jurisdictions (states, territories, tribes, and local entities), federal agencies, and pharmacy partners order vaccines from the federal government.
- **VTrckS Provider Order Portal (VPOP):** CDC’s platform where federal entity providers report their on-hand COVID-19 vaccine inventory each day.
- **Immunization Data Lake (IZDL):** A cloud-hosted data repository to receive, store, manage, and analyze deidentified COVID-19 vaccination data.
If you would like to learn more about the techniques used go to the [CDC website](https://www.cdc.gov/coronavirus/2019-ncov/vaccines/reporting-vaccinations.html?CDC_AA_refVal=https%3A%2F%2Fwww.cdc.gov%2Fcoronavirus%2F2019-ncov%2Fvaccines%2Fdistributing%2Fabout-vaccine-data.html).  
  
The data has 64 observations of 63 variables 

[Economic data by state](https://apps.bea.gov/regional/downloadzip.cfm)  
This data set was collected by the BEA through a mixture of methods in order to more accurately assess and contextualize the data, the methods used include:  
- **Administrative Data:** Aquiring the data from a variaty of sources directly including the Census Bureau, the Internal Revenue Service (IRS), the Bureau of Labor Statistics (BLS). This data includes tax records, social security payments, unemployment benefits, and other forms of government assistance.
- **Surveys and Questionnaires:** BEA may use surveys conducted by various government agencies or private organizations to collect data on wages, salaries, and other sources of income, as well as consumer spending patterns.
- **Industry data:** Data from various industries and sectors, such as retail sales, services, and manufacturing, are used to estimate consumer spending and income from different sources.
- **Interpretation and Estimation:** The BEA can extrapolate from these previous techniques using a variety of methods to create a more wholistic picture of consumer spending and the overall economic state.  

This data has 180 observations, however, each of these observations is tripled so there are only 60 unique observations with 308 variables.

# Background Research

[COVID-19 vaccine doses administered per 100 people, by income group](https://ourworldindata.org/grapher/cumulative-covid-vaccinations-income-group)
- According to the data given in this source, the Covid-19 vaccination rates for high income and upper-middle-class are significantly higher than those low-income and slightly higher than lower middle-class income groups.
- While this source examines the world trends, we wish to investigate the connection between different income groups and COVID-19 immunization in the United States.

[COVID-19 has had 'devastating and disproportionate' impact on poorest Americans, report finds](https://abcnews.go.com/Health/covid-19-devastating-disproportionate-impact-poorest-americans-report/story?id=83893515#:~:text=Stream%20on-,COVID%2D19%20has%20had%20'devastating%20and%20disproportionate'%20impact%20on,death%20rates%20of%20wealthy%20Americans.&text=Photographer%20Julia%20Rendleman%20uses%20her,in%20America%20throughout%20the%20pandemic.)
- This source aims to discuss the impacts that COVID-19 has had on those belonging to lower socioeconomic classes, similar to our project goal.
- Unlike our project, this source talks about death rates comparisons for different SES. While this can be connected to vaccination rates, we will specifically be focusing on vaccination rates for our data and then discussing some longer-term implications of lowered vaccination rates (such as death rates).

[Socioeconomic disparities and COVID-19 vaccination acceptance: a nationwide ecologic study](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8183100/)
- Lower socioeconomic status was associated with lower COVID-19 vaccination percentage, which is similar to the story our investigation plans to talk about.
- We want to analyze the relationship between SES and COVID-19 vaccination in the U.S., while this source looks at the trend for Israel.

[COVID-19 Hits the Poor Harder, but Scaled-Up Testing Can Help](https://www.imf.org/en/Blogs/Articles/2020/12/03/blog-covid-19-hits-the-poor-harder-but-scaled-up-testing-can-help)
- Runs model-based analysis on the possible impact of different solutions to the disproportionate rates of COVID-19 infections (eg. more accessible testing, income support). Similar to our project, factors in income as one of the variables of interest in their analysis.
- The analysis run in this source also factors in age, gender, and other demographics in their model while we would only be analyzing SES vs vaccination rate. 

[Inequality in the Time of COVID-19](https://www.imf.org/external/pubs/ft/fandd/2021/06/inequality-and-covid-19-ferreira.htm)
- Found that the mortality burden of the pandemic is positively correlated with national income per capita, despite the superior health and public prevention systems in rich countries. This contradicts the trend that we predicted our data analysis to show and built our research question around.
- Highlights how difficult it is to operationalize “economic inequality”, which we also touch on in our project proposal and reasoning behind why we chose to look at regional economic groups as opposed to other measures such as GDP per capita or household income. 

