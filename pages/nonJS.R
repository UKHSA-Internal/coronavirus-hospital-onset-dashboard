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
        "This dashboard shows the location at where a patient was when they had their first COVID-19 positive PCR test, in relation to a hospital attendance in A&E or inpatient admission."
    ),
    tags$p(
        class="govuk-body",
        "This is the non javascript version of the dashboard which has reduced functionality. None of the interactive graphs and tables are available. You will have to enable javascript to use those."
    ),
    tags$p(
        class="govuk-body",
        "You can download the data as a CSV file."
    ),
    tags$a(
        class="govuk-button",
        href="#",
        "Download data"
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
