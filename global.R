## PHE COVID19 HCAI Dashboard
##  on pull, to get package dependencies, run
#   renv::init()
#   future updates can be run with renv::restore()

renv::restore()

library(shiny)
library(shinyGovukFrontend)
library(tidyverse)
library(lubridate)
library(sass)
library(plotly)
library(DT)



## font stylings for plotlys
font_style <- list(
  family = c("GDS Transport","Arial","sans-serif"),
  size = 14,
  color = "black"
)


#### SOURCE DATA ##############################################################

hcai <- readr::read_csv("./hcai.csv")

# Transform and prep
hcai <- hcai %>%
  mutate(wk_start=ymd(wk_start),
    ecds_last_update=ymd(ecds_last_update),
    sus_last_update=ymd(sus_last_update),
    hcai_group=factor(hcai_group,
      levels = c("Unlinked",
        "CO",
        "HO.iHA",
        "HO.pHA",
        "HO.HA"
      )
    )
  ) %>%
  mutate(nhs_region=factor(nhs_region,
    levels=c(
      "LONDON",
      "SOUTH EAST",
      "SOUTH WEST",
      "EAST OF ENGLAND",
      "MIDLANDS",
      "NORTH EAST AND YORKSHIRE",
      "NORTH WEST"
    ))
  ) %>%
  mutate(
    provider_code=if_else(is.na(trust_name),NA_character_,provider_code),
    provider_code=fct_explicit_na(factor(provider_code),"Unknown"),
    trust_name=fct_explicit_na(factor(trust_name),"Unknown"),
    trust_type=fct_explicit_na(factor(trust_type),"Unknown"),
    nhs_region=fct_explicit_na(factor(nhs_region),"Unknown"),
    hcai_group=fct_explicit_na(hcai_group,"Unlinked"),
    linkset=if_else(hcai_group=="Unlinked","SGSS",linkset)
  )
