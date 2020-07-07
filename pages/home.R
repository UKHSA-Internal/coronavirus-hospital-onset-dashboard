home <- function(title, content) {
  tagList(
    tags$title("Healthcare associated COVID-19 Surveillance in England"),
    h1(
        class="govuk-caption-l govuk-!-margin-0 govuk-!-padding-top-3",
        "Home"
    ),
    tags$hr(
        class="govuk-section-break govuk-section-break--m govuk-!-margin-top-2 govuk-!-margin-bottom-4 govuk-section-break--visible"
    ),
    includeMarkdown("content/home.md")
  )
}
