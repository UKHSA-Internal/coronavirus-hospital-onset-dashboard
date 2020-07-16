## PHE COVID19 HCAI Dashboard
# Define UI for application
#   Current layout:
#     + top navigation (3 panels; home, dashboard, info/methods)
#     + sidebar with filters
#     + three rows of information on main dashboard panel
#       + data indicators
#       + counts graph
#       + proportions graph

tags$body(
  class="govuk-template__body js",
  bootstrapPage(
    tags$div(
      tags$head(
        tags$link(href = "main.css", rel = "stylesheet", type = "text/css"),
        tags$script(src = "js/aria-tooltips.js"),
        tags$title("Healthcare associated COVID-19 Surveillance in England")
      ),
      header(serviceName="Healthcare associated COVID-19 Surveillance in England"),
      banner("banner", "beta", 'This is a new service – your <a class="govuk-link" href="mailto:coronavirus-hcai@phe.gov.uk">feedback</a> will help us to improve it.'),
      tags$div(class="govuk-width-container",
        tags$main(
          id="main-content",
          class="govuk-main-wrapper",
          role="main",
          router_ui()
        )
      ),
      footer(TRUE)
    )
  )
)
