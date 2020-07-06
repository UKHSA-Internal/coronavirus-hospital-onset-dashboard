template <- function(title, current_page, content) {
  tagList(
    tags$div(
      class="dashboard-container",
      sideNavigation(current_page),
      tags$div(
        class="dashboard-content",
        tagList(content)
      )
    )
  )
}
