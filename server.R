# Define server logic required to draw a histogram
server <- function(input, output) {

  # Load data
  hcai <- read_csv("./hcai.csv")
  trust_names <- read_csv("./lookup/trust_names.csv")

  # Join data
  hcai <- left_join(hcai,trust_names,by=c("provider_code"="trust_code"))

  # Mutate
  hcai <- hcai %>%
    mutate(wk_start=ymd(wk_start),
      ecds_last_update=ymd(ecds_last_update),
      sus_last_update=ymd(sus_last_update),
      hcai_group=if_else(grepl("CO",hcai_group),"CO",hcai_group),
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
    mutate(provider_code=if_else(is.na(trust_name),NA_character_,provider_code),
      provider_code=fct_explicit_na(factor(provider_code),"Unknown"),
      trust_name=fct_explicit_na(factor(trust_name),"Unknown"),
      trust_type=fct_explicit_na(factor(trust_type),"Unknown"),
      nhs_region=fct_explicit_na(factor(nhs_region),"Unknown"),
      hcai_group=fct_explicit_na(hcai_group,"Unlinked"),
      linkset=if_else(hcai_group=="Unlinked","SGSS",linkset)
    )

  # SETUP INPUTS ON TYPE, GEOGRPAHY, CODE & NAME
  output$nhs_region= renderUI({
    shinyGovstyle::select_Input("nhs_region",
      label = "NHS Region",
      select_value = c("ALL",levels(droplevels(factor(hcai$nhs_region),
        exclude="Unknown"))),
      select_text = c("ALL")
    )
  })

  output$trust_type= renderUI({
    shinyGovstyle::select_Input("trust_type",
      label = "Trust type",
      select_value = c("ALL",levels(droplevels(factor(hcai$trust_type),
        exclude="Unknown"))),
      select_text = c("ALL")
    )
  })

  output$trust_code= renderUI({
    shinyGovstyle::select_Input("trust_code",
      label = "Trust code",
      select_value = c("ALL",levels(droplevels(factor(hcai$provider_code),
        exclude="Unknown"))),
      select_text = c("ALL")
    )
  })

  output$trust_name= renderUI({
    shinyGovstyle::select_Input("trust_name",
      label = "Trust name",
      select_value = c("ALL",levels(droplevels(factor(hcai$trust_name),
        exclude="Unknown"))),
      select_text = c("ALL")
    )
  })

  # linked cases
  output$linked_cases= renderUI({
    shinyGovstyle::select_Input("linked_cases",
      label = "Case inclusion",
      select_value = c(1,0),
      select_text = c("Include unlinked cases","Linked cases only")
    )
  })

  # DATE FILTERS
  output$filterdate = renderUI({
    shinyGovstyle::date_Input("filterdate",
      label="Filter dates before",
      hint_label = "For example, 31 3 1980"
    )
  })

  # Rubbish
  output$distPlot <- renderPlot({
    hist(rnorm(input$obs))
  })
}
