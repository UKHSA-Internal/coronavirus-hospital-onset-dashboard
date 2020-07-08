# sideNavigation.R
sideNavigation <- function(page) {
  tags$div(
    class="dashboard-menu",
    tags$nav(
      class="moj-side-navigation",
      tags$ul(
        class="moj-side-navigation__list",
        if (page == 'home') {
          tags$li(
            class="moj-side-navigation__item moj-side-navigation__item--active",
            a(class = "item", href = "#!/", "Home")
          )
        } else {
          tags$li(
            class="moj-side-navigation__item",
            a(class = "item", href = "#!/", "Home")
          )
        },
        if (page == 'dashboard') {
          tags$li(
            class="moj-side-navigation__item moj-side-navigation__item--active",
            a(class = "item", href = "#!/dashboard", "Dashboard")
          )
        } else {
          tags$li(
            class="moj-side-navigation__item",
            a(class = "item", href = "#!/dashboard", "Dashboard")
          )
        },
        if (page == 'information') {
          tags$li(
            class="moj-side-navigation__item moj-side-navigation__item--active",
            a(class = "item", href = "#!/information", "Information")
          )
        } else {
          tags$li(
            class="moj-side-navigation__item",
            a(class = "item", href = "#!/information", "Information")
          )
        }
      )
    )
  )
}
