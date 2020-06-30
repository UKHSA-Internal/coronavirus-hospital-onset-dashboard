# Define UI for application that draws a histogram
fluidPage(
  tags$html(lang="en"),
  tags$head(
    tags$link(href = "main.css", rel = "stylesheet", type = "text/css"),
    tags$link(href = "govuk.css", rel = "stylesheet", type = "text/css")
  ),
  font(),
  shinyGovukFrontend::header("PHE", "HCAI Dashboard", logo="shinyGovukFrontend/images/moj_logo.png"),
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
            uiOutput('nhs_region'),
            uiOutput('trust_type'),
            uiOutput('trust_code'),
            uiOutput('trust_name'),
            uiOutput('link'),
            uiOutput('filter_date'),
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
