accessibility <- function(title, content) {
  tagList(
    tags$title("Accessibility statement - Healthcare associated COVID-19 Surveillance in England"),
    includeMarkdown("content/accessibility.md")
  )
}
