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

  output$distPlot <- renderPlot({
    hist(rnorm(input$obs))
  })
}
