dashboard <- function(title, content) {
  tagList(
    tags$title("Dashboard - Healthcare associated COVID-19 Surveillance in England"),
    h1(
        class="govuk-caption-l govuk-!-margin-0 govuk-!-padding-top-3",
        "Dashboard"
    ),
    tags$hr(
        class="govuk-section-break govuk-section-break--m govuk-!-margin-top-2 govuk-!-margin-bottom-4 govuk-section-break--visible"
    ),
    tags$p("Select a trust or NHS region to customise the dashboard data."),
    tags$div(
      class="util-flex util-flex-wrap",
      selectInput(
        "nhs_region",
        label = "NHS region",
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
        select_text = c("Hospital linked cases only","Include all cases"),
        select_value = c(0, 1)
      ),
      conditionalPanel(
        condition = 'input.trust_code == "BLANK"',
        numericInput(
          inputId = "rows",
          label = "rows",
          value = nrow(hcai),
          min = 0,
          max = nrow(hcai),
          step = 1
        )
      )
    ),
    tags$div(
      class="govuk-form-group govuk-!-margin-bottom-0",
      actionButton(
        "reset",
        class="govuk-button",
        label="Reset"
      )
    ),
    tags$hr(
        class="govuk-section-break govuk-section-break--m govuk-!-margin-top-2 govuk-!-margin-bottom-0 govuk-section-break--visible"
    ),
    tags$details(
      class="govuk-details govuk-!-margin-top-4 govuk-!-margin-bottom-1",
      "data-module"="govuk-details",
      tags$summary(
        class="govuk-details__summary",
        tags$span(
          class="govuk-details__summary-text",
          "Onset categories description"
        )
      ),
      tags$div(
        class="govuk-details__text",
        tags$ul(
          class="govuk-list govuk-list--bullet",
          tags$li("Community-onset (CO)"),
          tags$li("Hospital-onset indeterminate healthcare-associated (HO.iHA)"),
          tags$li("Hospital-onset probable healthcare-associated (HO.pHA)"),
          tags$li("Hospital-onset definite healthcare-associated (HO.HA)"),
          tags$li("No hospital record (NHR)"),
        )
      )
    ),
    tags$div(
      class = "util-flex util-flex-wrap govuk-!-margin-bottom-4",
      tags$div(
        class="util-flex util-flex-col govuk-!-margin-right-9 govuk-!-margin-top-4",
        h2(
          class="govuk-body govuk-!-font-weight-bold govuk-!-margin-bottom-1",
          "Number of cases"
        ),
        tags$div(
          class="util-flex",
          uiOutput('valuebox_total', class = "govuk-!-margin-right-6"),
          uiOutput('valuebox_prop'),
        )
      ),
      tags$div(
        class="util-flex util-flex-col govuk-!-margin-right-9 govuk-!-margin-top-4",
        h2(
          class="govuk-body govuk-!-font-weight-bold govuk-!-margin-bottom-1",
          "Onset category breakdown"
        ),
        tags$div(
          class="util-flex",
          uiOutput('valuebox_co', class = "govuk-!-margin-right-6"),
          uiOutput('valuebox_hoiha', class = "govuk-!-margin-right-6"),
          uiOutput('valuebox_hopha', class = "govuk-!-margin-right-6"),
          uiOutput('valuebox_hoha')
        )
      ),
      tags$div(
        class="util-flex util-flex-col govuk-!-margin-top-4",
        h2(
          class="govuk-body govuk-!-font-weight-bold govuk-!-margin-bottom-1",
          "Hospital data reporting"
        ),
        tags$div(
          class="util-flex",
          uiOutput('valuebox_ecds', class = "govuk-!-margin-right-6"),
          uiOutput('valuebox_sus')
        )
      )
    ),
    # Show a plot of the generated distribution
    tags$div(
      class="dashboard-panel govuk-!-padding-5",
      h2(
        class="govuk-heading-m govuk-!-margin-bottom-2",
        "Number and proportion of COVID-19 cases by onset category"
      ),
      p(class="util-text-max-width govuk-!-font-weight-bold",
        textOutput("data_for_text",inline=TRUE)
      ),
      tabsetPanel(
        id = "dataPanels",
        tabPanel(
          title = "Chart",
          tags$h4(class="govuk-visually-hidden", "Interactive bar chart displaying the number of COVID-19 cases by onset category."),
          tags$p(class="govuk-visually-hidden", "Please note this bar chart is not accessible via assistive technologies. We have provided the same data in an accessible tabular format under the tab called 'Data'."),
          plotly::plotlyOutput("plotly_count"),
          plotly::plotlyOutput("plotly_proportion")
        ),
        tabPanel(
          title = "Data",
          DT::dataTableOutput("data_table")
        )
      )
    )
  )
}
