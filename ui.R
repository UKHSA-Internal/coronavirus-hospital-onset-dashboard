# Define UI for application that draws a histogram
ui <- fluidPage(
  title = "HCAI Dashboard",
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
            plotOutput("distPlot")
          )
        ),
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
