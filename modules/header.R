# Header.R
header <- function(id,serviceName="Service name") {
  tagList(
    tags$header(
      class="govuk-header",
      role="banner",
      "data-module"="govuk-header",
      tags$div(
        class="govuk-header__container govuk-width-container",
        tags$div(
          class="govuk-header__logo",
          tags$a(
            class="phe-header",
            href="https://www.gov.uk/government/organisations/public-health-england",
            tags$img(
              class="phe-header-logo",
              src="images/phe-logo.png",
              alt="Public Health England logo"
            ),
            tags$span(
              class="govuk-visually-hidden",
              "Public Health England"
            )
          )
        ),
        tags$div(
          class="govuk-header__content",
          tags$a(
            class="govuk-header__link govuk-header__link--service-name",
            href="#!/",
            serviceName
          )
        )
      )
    )
  )
}
