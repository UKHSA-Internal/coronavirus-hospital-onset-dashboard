# Coronavirus Hospital Onset Dashboard

This is the main source code for the [Coronavirus Hospital Onset Dashboard](https://coronavirus-hospital-onset.data.gov.uk) service.

> __DISCLAIMER: Dashboard currently in development and all data is synthetic__

This dashboard provides information on patients in hospital who tested positive for infection with SARS-CoV-2 (the virus that causes COVID-19) to understand whether the infection occurred before or during the patient's stay in hospital.

This dashboard indicates the NHS Trust or Independent Sector provider where a patient was located (hospital admission or A&E attendance) when they received their first COVID-19 positive test result. This location does not always indicate where a patient received hospital care for COVID-19. Patients attending A&E who tested positive are assumed to have subsequently been admitted to hospital unless their hospital records indicate otherwise.

Due to variation in reporting on a hospital level, data is subject to change, particularly in the most recent six weeks. This may result in changes to both the provider where a case is reported against, and in the healthcare-associated infection category. 

## Build

If you want to build this locally, you'll need to download and install [R](https://cran.r-project.org/mirrors.html) and [RStudio Desktop](https://rstudio.com/products/rstudio/#rstudio-desktop)

Once you clone this repo, run `renv::restore()` on your first instance in RStudio to load up the managed package list.

## Credits

This service is developed and maintained by [Public Health England](https://www.gov.uk/government/organisations/public-health-england).
