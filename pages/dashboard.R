dashboard <- function(title, content) {
  tagList(
    tabPanel(title = "Dashboard",
      sidebarLayout(
        sidebarPanel(
          selectInput(
            "nhs_region",
            label = "NHS Region",
            select_value = c("ALL",
              levels(
                droplevels(
                  factor(hcai$nhs_region),
                  exclude = "Unknown"))
            ),
            select_text = c("ALL",
              levels(
                droplevels(
                  factor(hcai$nhs_region),
                  exclude = "Unknown"))
            )
          ),
          selectInput(
            "trust_type",
            label = "Trust type",
            select_value = c("ALL",
              levels(
                droplevels(
                  factor(hcai$trust_type),
                  exclude = "Unknown"))
            ),
            select_text = c("ALL",
              levels(
                droplevels(
                  factor(hcai$trust_type),
                  exclude = "Unknown"))
            )
          ),
          selectInput(
            "trust_code",
            label = "Trust code",
            select_value = c("ALL",
              levels(
                droplevels(
                  factor(hcai$provider_code),
                  exclude = "Unknown"))
            ),
            select_text = c("ALL",
              levels(
                droplevels(
                  factor(hcai$provider_code),
                  exclude = "Unknown"))
            )
          ),
          selectInput(
            "trust_name",
            label = "Trust name",
            select_value = c("ALL",
              levels(
                droplevels(
                  factor(hcai$trust_name),
                  exclude = "Unknown"))
            ),
            select_text = c("ALL",
              levels(
                droplevels(
                  factor(hcai$trust_name),
                  exclude = "Unknown"))
            )
          ),
          selectInput(
            "link",
            label = "Case inclusion",
            select_text = c("Include unlinked cases",
              "Linked cases only"),
            select_value = c(1, 0)
          ),
          shiny::dateInput(
            "date_filter",
            label = "Filter dates before",
            min = min(hcai$wk_start),
            max = max(hcai$wk_start),
            value = "2020-03-01",
            format = "dd MM yyyy"
          ),
          # text for sidebar
          includeMarkdown("content/filter.md")
    tags$title("Dashboard - Healthcare associated COVID-19 Surveillance in England"),
        ),
        # Show a plot of the generated distribution
        mainPanel(
          div(
            style = "display: flex; flex-wrap: wrap;",
            uiOutput('valuebox_total', class = "valuebox"),
            uiOutput('valuebox_prop', class = "valuebox"),
            uiOutput('valuebox_co', class = "valuebox"),
            uiOutput('valuebox_hoiha', class = "valuebox"),
            uiOutput('valuebox_hopha', class = "valuebox"),
            uiOutput('valuebox_hoha', class = "valuebox"),
          ),
          tabsetPanel(tabPanel(title = "Dashboard",
            plotly::plotlyOutput("plotly_count"),
            plotly::plotlyOutput("plotly_proportion")
          ),
            tabPanel(title = "Data table",
              h1("Data table"),
              DT::dataTableOutput("data_table")
            )
          )
        )
      )
    )
  )
}
