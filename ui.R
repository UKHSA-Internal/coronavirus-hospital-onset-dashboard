# Define UI for application that draws a histogram
tags$div(
  tags$html(lang="en", class="govuk-template"),
  tags$head(
    tags$link(href = "main.css", rel = "stylesheet", type = "text/css"),
    tags$link(href = "govuk.css", rel = "stylesheet", type = "text/css")
  ),
  tags$body(class="govuk-template__body"),
  font(),
  shinyGovukFrontend::header("PHE", "HCAI Dashboard", logo="shinyGovukFrontend/images/moj_logo.png"),
  tags$div(class="govuk-width-container",
    gov_layout(
      navbarPage("HCAI Dashboard",
        tabPanel(title = "Home",
          includeMarkdown("content/home.md"),
          plotOutput("norm"),
          actionButton("renorm", "Resample")
        ),
        tabPanel(title = "Dashboard",
          sidebarLayout(
            sidebarPanel(
              shinyGovstyle::select_Input(
                uiOutput('trust_type'),
                "nhs_region",
                uiOutput('trust_code'),
                label = "NHS Region",
                uiOutput('trust_name'),
                select_value = c("ALL",
                                 uiOutput('link'),
                                 levels(droplevels(factor(hcai$nhs_region),
                                                   uiOutput('filter_date'),
                                                   exclude = "Unknown")
                                 )),
                select_text = c("ALL",
                                levels(droplevels(factor(hcai$nhs_region),
                                                  exclude = "Unknown")
                                ))
              ),
              # uiOutput('nhs_region'),
              shinyGovstyle::select_Input(
                "trust_type",
                label = "Trust type",
                select_value = c("ALL",
                                 levels(droplevels(factor(hcai$trust_type),
                                                   exclude = "Unknown")
                                 )),
                select_text = c("ALL",
                                levels(droplevels(factor(hcai$trust_type),
                                                  exclude = "Unknown")
                                ))
              ),
              # uiOutput('trust_type'),
              shinyGovstyle::select_Input(
                "trust_code",
                label = "Trust code",
                select_value = c("ALL",
                                 levels(droplevels(factor(hcai$provider_code),
                                                   exclude = "Unknown")
                                 )),
                select_text = c("ALL",
                                levels(droplevels(factor(hcai$provider_code),
                                                  exclude = "Unknown")
                                ))
              ),
              # uiOutput('trust_code'),
              shinyGovstyle::select_Input(
                "trust_name",
                label = "Trust name",
                select_value = c("ALL",
                                 levels(droplevels(factor(hcai$trust_name),
                                                   exclude = "Unknown")
                                 )),
                select_text = c("ALL",
                                levels(droplevels(factor(hcai$trust_name),
                                                  exclude = "Unknown")
                                ))
              ),
              # uiOutput('trust_name'),
              shinyGovstyle::select_Input(
                # "linked_cases",
                "link",
                label = "Case inclusion",
                select_text = c("Include unlinked cases", "Linked cases only"),
                select_value = c(1, 0)
              ),
              # uiOutput('link'),
              shinyGovstyle::date_Input(
                inputId = "filter_date",
                label = "Please enter your birthday"),
              # uiOutput('filter_date'),
            # text for sidebar
              includeMarkdown("content/filter.md")
            ),
            # Show a plot of the generated distribution
            mainPanel(
              tabsetPanel(
                tabPanel(title = "Dashboard",
                  h1("Dashboard"),
                  div(style = "display: flex; flex-wrap: wrap;",
                    uiOutput('valuebox01', class="valuebox"),
                    uiOutput('valuebox02', class="valuebox"),
                    uiOutput('valuebox03', class="valuebox"),
                    uiOutput('valuebox04', class="valuebox"),
                  ),
                  plotly::plotlyOutput("plot_count")
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
  shinyGovstyle::footer(TRUE)
)
