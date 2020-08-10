## PHE COVID19 HCAI Dashboard

tags$body(
  class="govuk-template__body non-js",
  bootstrapPage(
    tagList(
      tags$script("document.body.className = 'govuk-template__body js';"),
      cookieBanner("global-cookie-message"),
      tags$head(
        tags$link(href="crown.ico", rel="shortcut icon"),
        tags$link(href = "main.css", rel = "stylesheet", type = "text/css"),
        tags$script(src = "main.js"),
        tags$title("Hospital-onset COVID-19 surveillance in England"),
        includeHTML("google-analytics.html")
      ),
      header(serviceName="Hospital-onset COVID-19 surveillance in England"),
      banner("banner", "beta", 'This is a new service – your <a class="govuk-link" href="mailto:coronavirus-hcai@phe.gov.uk">feedback</a> will help us to improve it.'),
      tags$div(
        id="main-outer",
        class="govuk-width-container",
        tags$main(
          id="main-content",
          class="govuk-main-wrapper loader",
          role="main",
          router_ui(),
          nonJS()
        )
      ),
      footer(TRUE)
    )
  )
)
