nonJS <- function() {
  tags$div(
    class="non-js util-text-max-width",
    tags$title("Methods - Healthcare associated COVID-19 Surveillance in England"),
    h1(
        class="govuk-caption-l govuk-!-margin-0 govuk-!-padding-top-3",
        "Dashboard"
    ),
    tags$hr(
        class="govuk-section-break govuk-section-break--m govuk-!-margin-top-2 govuk-!-margin-bottom-4 govuk-section-break--visible"
    ),
    tags$p(
        class="govuk-body",
        "Content describing the dashboard and what's not supported without JS. We could then offer the download of the data. Perhaps we could display the data in a table?"
    ),
    h1(
        class="govuk-caption-l govuk-!-margin-0 govuk-!-padding-top-3",
        "Methods"
    ),
    tags$hr(
        class="govuk-section-break govuk-section-break--m govuk-!-margin-top-2 govuk-!-margin-bottom-4 govuk-section-break--visible"
    ),
    tags$div(
        class="markdown util-text-max-width",
        includeMarkdown("content/methods.md")
    )
  )
}
