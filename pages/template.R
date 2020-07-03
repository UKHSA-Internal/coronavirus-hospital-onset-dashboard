template <- function(title, content) {
  tagList(
      menu,
      h1(title),
      tagList(content)
  )
}
