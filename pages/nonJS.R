nonJS <- function() {
  tags$div(
    class="non-js util-text-max-width",
    tags$title("Hospital-onset COVID-19 surveillance in England"),
    tags$h1(
        class="govuk-caption-l govuk-!-margin-0 govuk-!-padding-top-3",
        "Dashboard"
    ),
    tags$hr(
        class="govuk-section-break govuk-section-break--m govuk-!-margin-top-2 govuk-!-margin-bottom-4 govuk-section-break--visible"
    ),
    tags$p(
        class="govuk-body",
        "This dashboard provides information on patients in hospital who tested positive for infection with SARS-CoV-2 (the virus that causes COVID-19) to understand whether the infection occurred before or during the patient's stay in hospital."
    ),
    tags$p(
        class="govuk-body",
        "This is the non-javascript version of the dashboard, which does not show interactive graphs and tables. To view those, you will need to enable javascript."
    ),
    tags$p(
        class="govuk-body",
        "You can download the data as a CSV file."
    ),
    tags$a(
        class="govuk-button",
        href="https://raw.githubusercontent.com/publichealthengland/coronavirus-hospital-onset-dashboard/development/data/hcai.csv",
        target="_blank",
        "Download data"
    ),
    tags$h1(
        class="govuk-caption-l govuk-!-margin-0 govuk-!-padding-top-3",
        "About the data"
    ),
    tags$hr(
        class="govuk-section-break govuk-section-break--m govuk-!-margin-top-2 govuk-!-margin-bottom-4 govuk-section-break--visible"
    ),
    tags$div(
        class="markdown util-text-max-width",
        includeMarkdown("content/about.md")
    ),
    tags$h1(
        class="govuk-caption-l govuk-!-margin-0 govuk-!-padding-top-3",
        "Accessibility"
    ),
    tags$hr(
        class="govuk-section-break govuk-section-break--m govuk-!-margin-top-2 govuk-!-margin-bottom-4 govuk-section-break--visible"
    ),
    tags$div(
        class="markdown util-text-max-width",
        includeMarkdown("content/accessibility.md")
    )
  )
}
