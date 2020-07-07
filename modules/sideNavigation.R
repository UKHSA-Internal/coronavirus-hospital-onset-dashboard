# sideNavigation.R
sideNavigation <- function(page) {
  tags$div(
    class="dashboard-menu",
    tags$nav(
      class="moj-side-navigation",
      #h2(page),
      tags$ul(
        class="moj-side-navigation__list",
        tags$li(
          class="moj-side-navigation__item moj-side-navigation__item--active",
          a(class = "item", href = "#!/", "Home")),
        tags$li(
          class="moj-side-navigation__item",
          a(class = "item", href = "#!/dashboard", "Dashboard")),
        tags$li(
          class="moj-side-navigation__item",
          a(class = "item", href = "#!/information", "Information"))
      )
    )
  )
}
