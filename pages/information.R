information <- function(title, content) {
  tagList(
    tags$title("Information - Healthcare associated COVID-19 Surveillance in England"),
    h1(
        class="govuk-caption-l govuk-!-margin-0 govuk-!-padding-top-3",
        "Information"
    ),
    tags$hr(
        class="govuk-section-break govuk-section-break--m govuk-!-margin-top-2 govuk-!-margin-bottom-4 govuk-section-break--visible"
    ),
    includeMarkdown("content/information.md")
  )
}
