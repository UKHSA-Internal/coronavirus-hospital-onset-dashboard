home <- function(title, content) {
  tagList(
    tags$title("Healthcare associated COVID-19 Surveillance in England"),
    includeMarkdown("content/home.md")
  )
}
