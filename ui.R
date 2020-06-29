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
        sliderInput(inputId = "num",
          label = "Choose a number",
          value = 25, min = 1, max = 100),
        plotOutput("hist")),
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
