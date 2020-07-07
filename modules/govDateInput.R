# govDateInput.R

dateYMD <- function(date = NULL, argName = "value") {
  if (!length(date)) return(NULL)
  if (length(date) > 1) warning("Expected `", argName, "` to be of length 1.")
  tryCatch(date <- format(as.Date(date), "%Y-%m-%d"),
    error = function(e) {
      warning(
        "Couldn't coerce the `", argName,
        "` argument to a date string with format yyyy-mm-dd",
        call. = FALSE
      )
    }
  )
  date
}

govDateInput <- function(inputId, label, value = NULL, min = NULL, max = NULL,
  format = "yyyy-mm-dd", startview = "month", weekstart = 0,
  language = "en", width = NULL, autoclose = TRUE,
  datesdisabled = NULL, daysofweekdisabled = NULL) {

  value <- dateYMD(value, "value")
  min <- dateYMD(min, "min")
  max <- dateYMD(max, "max")
  datesdisabled <- dateYMD(datesdisabled, "datesdisabled")

  value <- restoreInput(id = inputId, default = value)

  tags$div(id = inputId,
    class = "shiny-date-input form-group shiny-input-container util-until-desktop-full",
    style = if (!is.null(width)) paste0("width: ", validateCssUnit(width), ";"),

    tags$label(
      class = "govuk-label govuk-!-font-weight-bold",
      "for" = paste0(inputId, "_input"),
      label
    ),
    tags$input(type = "text",
               class = "govuk-input util-until-desktop-full",
               id = paste0(inputId, "_input"),
               `data-date-language` = language,
               `data-date-week-start` = weekstart,
               `data-date-format` = format,
               `data-date-start-view` = startview,
               `data-min-date` = min,
               `data-max-date` = max,
               `data-initial-date` = value,
               `data-date-autoclose` = if (autoclose) "true" else "false",
               `data-date-dates-disabled` =
                   # Ensure NULL is not sent as `{}` but as 'null'
                   jsonlite::toJSON(datesdisabled, null = 'null'),
               `data-date-days-of-week-disabled` =
                   jsonlite::toJSON(daysofweekdisabled, null = 'null')
    ),
    datePickerDependency
  )
}

datePickerDependency <- htmltools::htmlDependency(
  "bootstrap-datepicker", "1.6.4", c(href = "shared/datepicker"),
  script = "js/bootstrap-datepicker.min.js",
  stylesheet = "css/bootstrap-datepicker3.min.css",
  # Need to enable noConflict mode. See #1346.
  head = "<script>
(function() {
  var datepicker = $.fn.datepicker.noConflict();
  $.fn.bsDatepicker = datepicker;
})();
</script>"
)
