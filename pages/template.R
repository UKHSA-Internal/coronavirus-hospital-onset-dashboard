template <- function(title, content) {
  tagList(
    tags$div(
      class="dashboard-container",
      sideNavigation(title),
      tags$div(
        id="content",
        class="dashboard-content",
        tagList(content)
      )
    )
  )
}
