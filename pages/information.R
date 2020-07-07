information <- function(title, content) {
  tagList(
    tags$title("Information - Healthcare associated COVID-19 Surveillance in England"),
    includeMarkdown("content/information.md")
  )
}
