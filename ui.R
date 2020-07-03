## PHE COVID19 HCAI Dashboard
# Define UI for application
#   Current layout:
#     + top navigation (3 panels; home, dashboard, info/methods)
#     + sidebar with filters
#     + three rows of information on main dashboard panel
#       + data indicators
#       + counts graph
#       + proportions graph

# Setting up modules
header <- use("modules/header.R")

tags$div(
  tags$html(lang="en", class="govuk-template"),
  tags$head(
    tags$link(href = "main.css", rel = "stylesheet", type = "text/css"),
    tags$link(href = "govuk.css", rel = "stylesheet", type = "text/css")
  ),
  tags$body(class="govuk-template__body"),
  header$ui(),
  shinyGovukFrontend::banner("banner", "beta", 'This is a new service – your <a class="govuk-link" href="mailto:coronavirus-hcai@phe.gov.uk">feedback</a> will help us to improve it.'),
  header$ui(serviceName="COVID19 Weekly Trust Reporting"),
  tags$div(class="govuk-width-container",
    shinyGovukFrontend::gov_layout(
      navbarPage("COVID-19 HCAI Dashboard",
        tabPanel(title = "Home",
          includeMarkdown("content/home.md"),
          plotOutput("norm"),
          actionButton("renorm", "Resample")
        ),
        tabPanel(title = "Dashboard",
          sidebarLayout(
            sidebarPanel(
              shinyGovukFrontend::select_Input(
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
              shinyGovukFrontend::select_Input(
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
              shinyGovukFrontend::select_Input(
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
              shinyGovukFrontend::select_Input(
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
              shinyGovukFrontend::select_Input(
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
                plotly::plotlyOutput("plot_count"),
                plotly::plotlyOutput("plot_proportion")
              ),
                tabPanel(title = "Data table",
                  h1("Data table"),
                  DT::dataTableOutput("data_table")
                )
              )
            )
          )
        ),
        tabPanel(title = "Information",
          includeMarkdown("content/information.md")
        )
      )
    )
  ),
  shinyGovukFrontend::footer(TRUE)
)
