# sideNavigation.R
sideNavigation <- function(page) {
  tags$aside(
    class="dashboard-menu",
    tags$nav(
      class="moj-side-navigation govuk-!-padding-right-4 govuk-!-padding-top-2",
      #h2(page),
      tags$ul(
        class="moj-side-navigation__list",
        tags$li(
          class="moj-side-navigation__item",
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
