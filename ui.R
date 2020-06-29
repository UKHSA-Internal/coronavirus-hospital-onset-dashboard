# Define UI for application that draws a histogram
ui <- fluidPage(
  title = "HCAI Dashboard",
  font(),
  shinyGovstyle::header("PHE", "HCAI Dashboard", logo="shinyGovstyle/images/moj_logo.png"),
  gov_layout(size = "full",
    sliderInput(inputId = "num",
      label = "Choose a number",
      value = 25, min = 1, max = 100),
    plotOutput("hist"),
    tags$br(),
    tags$br(),
    tags$br(),
    tags$br(),
    tags$br()
  ),
  footer(TRUE)
)
