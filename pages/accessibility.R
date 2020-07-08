accessibility <- function(title, content) {
  tagList(
    tags$title("Accessibility statement - Healthcare associated COVID-19 Surveillance in England"),
    tags$a(
        class="govuk-back-link",
        href="#!/dashboard",
        "Back to dashboard"
    ),
    tags$div(
        class="markdown util-text-max-width",
        includeMarkdown("content/accessibility.md")
    )
  )
}
