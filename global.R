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
# github_data <- url("https://raw.githubusercontent.com/publichealthengland/coronavirus-hospital-onset-dashboard/master/data/hcai.csv")
data_s3_bucket <- "https://coronavirus-hospital-onset-data.s3.eu-west-2.amazonaws.com/ho_covid_wk_counts.csv"
hcai <- readr::read_csv(data_s3_bucket, col_types = cols())

#### UI AND NAV ELEMENTS ########################################################
# Setting up modules
source("modules/header.R")
source("modules/banner.R")
source("modules/footer.R")
source("modules/selectInput.R")
source("modules/sideNavigation.R")
source("modules/valueBox.R")
source("modules/cookieBanner.R")

# Pages
source("pages/template.R")
source("pages/dashboard.R")
source("pages/about.R")
source("pages/accessibility.R")
source("pages/cookies.R")
source("pages/nonJS.R")

# Pages
dashboard_page <- template("dashboard", dashboard())
about_page <- template("about", about())
ally_page <- accessibility()
cookies_page <- cookies()

# Creates router. We provide routing path, a UI as
# well as a server-side callback for each page.
router <- make_router(
  route("dashboard", dashboard_page, NA),
  route("about", about_page, NA),
  route("accessibility", ally_page, NA),
  route("cookies", cookies_page, NA)
)


## font stylings for plotlys
font_style <- list(
  family = '"GDS Transport",sans-serif',
  size = 14,
  color = "black"
)


#### PREP SOURCE DATA ###########################################################

unlinked <- "No hospital record"

# Transform and prep
hcai <- hcai %>%
  mutate(hcai_group=ifelse(hcai_group=="Unlinked",unlinked,hcai_group)) %>%
  mutate(wk_start=ymd(wk_start),
    ecds_last_update=ymd(ecds_last_update),
    sus_last_update=ymd(sus_last_update),
    hcai_group=factor(hcai_group,
      levels = c(
        "CO",
        "HO.iHA",
        "HO.pHA",
        "HO.HA",
        unlinked
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
    hcai_group=fct_explicit_na(hcai_group,unlinked)
  )



#### OUTPUT PLOTLY FUNCTION #####################################################

plotly_graph <- function(data) {

  p <- plot_ly(type='bar')

  for(col in levels(hcai$hcai_group)) {
    if(col %in% names(data)) {
      p <- p %>%
        add_trace(x=data$wk_start,
                  y=data[[col]],
                  name=col,
                  marker = list(
                    color = case_when(
                      col=="CO" ~ "#AC189F",
                      col=="HO.iHA" ~ "#B3C1D7",
                      col=="HO.pHA" ~ "#5694CA",
                      col=="HO.HA" ~ "#003078",
                      TRUE ~ "#B9BCBD"
                    )
                  ))
    }
  }

  if(max(rowSums(data[2:length(names(data))],na.rm=T))==1) {
    p <- p %>% layout(yaxis = list(tickformat = "%"))
  } else {
    p <- p %>% layout(yaxis = list(tickformat = ",digit"))

  }

  p <- p %>%
    layout(
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
           modeBarButtonsToRemove = list("zoom2d", "pan2d", "select2d", "lasso2d", "zoomIn2d", "zoomOut2d", "autoScale2d"))


  return(p)
}

