# selectInput.R
selectInput <- function(inputId, label, select_text, select_value) {
  tagList(
    tags$div(
      class="govuk-form-group govuk-!-margin-right-4 util-until-desktop-full",
      tags$label(
        HTML(label),
        class="govuk-label govuk-!-font-weight-bold",
        "for"=inputId
      ),
      tags$select(
        id = inputId,
        class="govuk-select util-until-desktop-full",
        Map(function(x,y){
          tags$option(value = y, x)
        }, x = select_text, y = select_value)
      )
    )
  )
}
