# Define UI for application that draws a histogram
tags$div(
  tags$html(lang="en", class="govuk-template"),
  tags$head(
    tags$link(href = "main.css", rel = "stylesheet", type = "text/css"),
    tags$link(href = "govuk.css", rel = "stylesheet", type = "text/css")
  ),
  tags$body(class="govuk-template__body"),
  shinyGovukFrontend::font(),
  shinyGovukFrontend::header("PHE", "HCAI Dashboard", logo="shinyGovukFrontend/images/moj_logo.png"),
  tags$div(class="govuk-width-container",
           shinyGovukFrontend::gov_layout(
             navbarPage("HCAI Dashboard",
                        tabPanel(title = "Home",
                                 includeMarkdown("content/home.md"),
                                 plotOutput("norm"),
                                 actionButton("renorm", "Resample")
                        ),
                        tabPanel(title = "HCAI by week",
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
                                     shinyGovukFrontend::date_Input(
                                       inputId = "filter_date",
                                       label = "Filter dates before"
                                     ),
                                     # text for sidebar
                                     includeMarkdown("content/filter.md")
                                   ),
                                   # Show a plot of the generated distribution
                                   mainPanel(
                                     tabsetPanel(
                                       tabPanel(title = "Dashboard",
                                                h1("Dashboard"),
                                                div(style = "display: flex; flex-wrap: wrap;",
                                                    uiOutput('valuebox_total', class="valuebox"),
                                                    uiOutput('valuebox_prop', class="valuebox"),
                                                    uiOutput('valuebox_co', class="valuebox"),
                                                    uiOutput('valuebox_hoiha', class="valuebox"),
                                                    uiOutput('valuebox_hopha', class="valuebox"),
                                                    uiOutput('valuebox_hoha', class="valuebox"),
                                                ),
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
