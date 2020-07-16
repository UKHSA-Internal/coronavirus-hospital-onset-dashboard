# Value Box

valueBox <- function(label,number,tooltipText="Current capacity target"){
  tagList(
    p(
      class="govuk-!-font-size-16 govuk-!-margin-bottom-0 govuk-caption-m",
      label
    ),
    tags$div(
      class="a11y-tip a11y-tip--no-delay",
      tags$h3(
        class="govuk-heading-m govuk-!-font-weight-regular govuk-!-margin-bottom-0 govuk-!-padding-top-0 a11y-tip__trigger",
        number
      ),
      tags$span(
        class="govuk-body a11y-tip__help",
        tooltipText
      )
    )
  )
}
