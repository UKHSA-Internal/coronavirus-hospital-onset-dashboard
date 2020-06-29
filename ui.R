# Define UI for application that draws a histogram
ui <- fluidPage(
  title = "HCAI Dashboard",
  uiOutput('sass'),
  font(),
  shinyGovstyle::header("PHE", "HCAI Dashboard", logo="shinyGovstyle/images/moj_logo.png"),
  gov_layout(size = "full",
    navbarPage("App Title",
      tabPanel(title = "Home",
        includeMarkdown("content/home.md"),
        plotOutput("norm"),
        actionButton("renorm", "Resample")
      ),
      tabPanel(title = "Dashboard",
        sidebarLayout(
          # Sidebar with a slider input
          sidebarPanel(
            uiOutput('nhs_region'),
            uiOutput('trust_type'),
            uiOutput('trust_code'),
            uiOutput('trust_name'),
            uiOutput('linked_cases'),
            uiOutput('filterdate'),
            includeMarkdown("content/filter.md"),
            sliderInput("obs",
              "Number of observations:",
              min = 0,
              max = 1000,
              value = 500
            )
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
                plotOutput("distPlot")
              ),
              tabPanel(title = "Data table",
                h1("Data table")
              )
            )
          )
        )
      ),
      tabPanel(title = "Information",
        includeMarkdown("content/information.md")
      )
    ),
    tags$br(),
    tags$br(),
    tags$br(),
    tags$br(),
    tags$br()
  ),
  footer(TRUE)
)
