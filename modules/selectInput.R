# selectInput.R
selectInput <- function(inputId, label, select_text, select_value) {
  tagList(
    tags$div(
      class="govuk-form-group",
      tags$label(
        HTML(label),
        class="govuk-label",
        "for"=inputId
      ),
      tags$select(
        id = inputId,
        class="govuk-select",
        Map(function(x,y){
          tags$option(value = y, x)
        }, x = select_text, y = select_value)
      )
    )
  )
}
