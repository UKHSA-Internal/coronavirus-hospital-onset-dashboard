# Define UI for application that draws a histogram
fluidPage(
  tags$html(lang="en"),
  tags$head(
    tags$link(href = "main.css", rel = "stylesheet", type = "text/css")
  ),
  font(),
  shinyGovstyle::header("PHE", "HCAI Dashboard", logo="shinyGovstyle/images/moj_logo.png"),
  gov_layout(size = "full",
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
              "nhs_region",
              label = "NHS Region",
              select_value = c("ALL",
                               levels(droplevels(factor(hcai$nhs_region),
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
  ),
  footer(TRUE)
)
