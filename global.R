## PHE COVID19 HCAI Dashboard
##  on pull, to get package dependencies, run
#   renv::restore()

#### STARTUP ####################################################################
## load required packages
library(shiny, warn.conflicts = FALSE)
library(shiny.router, warn.conflicts = FALSE)
library(dplyr, warn.conflicts = FALSE)
library(stringr, warn.conflicts = FALSE)
library(readr, warn.conflicts = FALSE)
library(forcats, warn.conflicts = FALSE)
library(tidyr, warn.conflicts = FALSE)
library(lubridate, warn.conflicts = FALSE)
library(sass, warn.conflicts = FALSE)
library(markdown, warn.conflicts = FALSE)
library(ggplot2, warn.conflicts = FALSE)
library(plotly, warn.conflicts = FALSE)
library(DT, warn.conflicts = FALSE)

## load data
hcai <- readr::read_csv("data/hcai.csv", col_types = cols())

#### UI AND NAV ELEMENTS ########################################################
# Setting up modules
source("modules/header.R")
source("modules/banner.R")
source("modules/footer.R")
source("modules/selectInput.R")
source("modules/sideNavigation.R")

# Pages
source("pages/template.R")
source("pages/dashboard.R")
source("pages/information.R")
source("pages/accessibility.R")

# Pages
dashboard_page <- template("dashboard", dashboard())
info_page <- template("information", information())
ally_page <- accessibility()

# Creates router. We provide routing path, a UI as
# well as a server-side callback for each page.
router <- make_router(
  route("dashboard", dashboard_page, NA),
  route("information", info_page, NA),
  route("accessibility", ally_page, NA)
)


## font stylings for plotlys
font_style <- list(
  family = '"GDS Transport",sans-serif',
  size = 14,
  color = "black"
)


#### PREP SOURCE DATA ###########################################################

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


#### OUTPUT PLOTLY FUNCTION #####################################################

plotly_graph <- function(data) {

  p <- plot_ly(type='bar')

  for(col in c("CO","HO.iHA","HO.pHA","HO.HA","Unlinked")) {
    if(col %in% names(data)) {
      p <- p %>%
        add_trace(x=data$wk_start,
                  y=data[[col]],
                  name=col,
                  # text = case_when(
                  #   col=="CO" ~ "Community onset",
                  #   col=="HO.iHA" ~ "Hospital onset indeterminate healthcare associated",
                  #   col=="HO.pHA" ~ "Hospital onset probable healthcare associated",
                  #   col=="HO.HA" ~ "Hospital onset healthcare associated",
                  #   TRUE ~ "No hospital record"
                  # ),
                  # hovertemplate = '%{text}: %{y}',
                  marker = list(
                    color = case_when(
                      col=="CO" ~ "#5694ca",
                      col=="HO.iHA" ~ "#ffdd00",
                      col=="HO.pHA" ~ "#003078",
                      col=="HO.HA" ~ "#d4351c",
                      TRUE ~ "#b1b4b6"
                    )
                  ))
    }
  }

  if(max(rowSums(data[2:length(names(data))]))==1) {
    p <- p %>% layout(yaxis = list(tickformat = "%"))
  } else {
    p <- p %>% layout(yaxis = list(tickformat = ",digit"))

  }

  p <- p %>%
    layout(
      # title = list(text = "<b>Patients first positive COVID-19 test, by HCAI category</b>",
      #              xref="container",
      #              x=0.01,
      #              y=0.9),
      barmode = 'stack',
      hovermode = 'x unified',
      font = font_style,
      legend = list(orientation = 'h',
                    y = '-0.2'),
      plot_bgcolor = '#f8f8f8',
      paper_bgcolor = '#f8f8f8',
      margin = list(l = 60,
                    r = 25,
                    b = 40,
                    t = 20, # 90 if title is added
                    pad = 5)
    ) %>%
    config(displaylogo = FALSE,
           modeBarButtons = list(list("toImage")))


  return(p)
}

