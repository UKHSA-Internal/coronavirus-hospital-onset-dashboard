template <- function(title, content) {
  tagList(
    tags$div(
      class="dashboard-container",
      sideNavigation(title),
      tags$div(
        class="dashboard-content",
        tagList(content)
      )
    )
  )
}
