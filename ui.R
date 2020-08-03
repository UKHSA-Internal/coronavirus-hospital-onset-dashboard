## PHE COVID19 HCAI Dashboard

tags$body(
  class="govuk-template__body js",
  bootstrapPage(
    tagList(
      cookieBanner("global-cookie-message"),
      tags$head(
        tags$link(href="crown.ico", rel="shortcut icon"),
        tags$link(href = "main.css", rel = "stylesheet", type = "text/css"),
        tags$script(src = "main.js"),
        tags$title("Healthcare associated COVID-19 Surveillance in England"),
        includeHTML("google-analytics.html")
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
