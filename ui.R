## PHE COVID19 HCAI Dashboard
# Define UI for application
#   Current layout:
#     + top navigation (3 panels; home, dashboard, info/methods)
#     + sidebar with filters
#     + three rows of information on main dashboard panel
#       + data indicators
#       + counts graph
#       + proportions graph


bootstrapPage(
  tags$div(
    tags$html(lang="en", class="govuk-template"),
    tags$head(
      tags$link(href = "main.css", rel = "stylesheet", type = "text/css"),
      tags$link(href = "govuk.css", rel = "stylesheet", type = "text/css")
    ),
    tags$body(class="govuk-template__body"),
    header(serviceName="COVID19 Weekly Trust Reporting"),
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

