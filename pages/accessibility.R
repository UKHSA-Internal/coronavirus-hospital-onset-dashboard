accessibility <- function(title, content) {
  tagList(
    tags$title("Accessibility statement - Healthcare associated COVID-19 Surveillance in England"),
    tags$a(
        class="govuk-back-link",
        href="#!/dashboard",
        "Back to dashboard"
    ),
    includeMarkdown("content/accessibility.md")
  )
}
