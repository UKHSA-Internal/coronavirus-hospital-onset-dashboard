cookies <- function(title, content) {
  tagList(
    tags$title("Cookies - Healthcare associated COVID-19 Surveillance in England"),
    tags$a(
        class="govuk-back-link js-gototop",
        href="#!/dashboard",
        "Back to dashboard"
    ),
    tags$div(
        class="util-text-max-width",
        tags$div(
            class="markdown",
            includeMarkdown("content/cookies.md")
        ),
        tags$table(
            class="govuk-table",
            tags$thead(
                class="govuk-table__head",
                tags$tr(
                    class="govuk-table__row",
                    tags$th(
                        class="govuk-table__header",
                        "scope"="col",
                        "Name"
                    ),
                    tags$th(
                        class="govuk-table__header",
                        "scope"="col",
                        "Purpose"
                    ),
                    tags$th(
                        class="govuk-table__header",
                        "scope"="col",
                        "Expires"
                    )
                )
            ),
            tags$tbody(
                class="govuk-table__body",
                tags$tr(
                    class="govuk-table__row",
                    tags$td(
                        class="govuk-table__cell",
                        "_ga, _gid"
                    ),
                    tags$td(
                        class="govuk-table__cell",
                        "These help us count how many people visit data.gov.uk by tracking if you’ve visited before"
                    ),
                    tags$td(
                        class="govuk-table__cell",
                        "_ga 2 years, _gid 24 hours"
                    )
                )
            )
        ),
        tags$div(
            class="govuk-form-group",
            tags$div(
                class="govuk-radios",
                tags$div(
                    class="govuk-radios__item",
                    tags$input(
                        class="govuk-radios__input",
                        id="allow-usage-cookies",
                        name="usage-cookies",
                        type="radio",
                        value="allow"
                    ),
                    tags$label(
                        class="govuk-label govuk-radios__label",
                        "for"="allow-usage-cookies",
                        "Use cookies that measure my website use"
                    )
                ),
                tags$div(
                    class="govuk-radios__item",
                    tags$input(
                        class="govuk-radios__input",
                        id="disallow-usage-cookies",
                        name="usage-cookies",
                        type="radio",
                        value="disallow"
                    ),
                    tags$label(
                        class="govuk-label govuk-radios__label",
                        "for"="disallow-usage-cookies",
                        "Do not use cookies that measure my website use"
                    )
                )
            )
        ),
        tags$h2(
            class="govuk-heading-m",
            "Strictly necessary cookies"
        ),
        tags$p(
            class="govuk-body",
            "These essential cookies do things like remember your cookie preferences, so we don't ask for them again."
        ),
        tags$p(
            class="govuk-body",
            "They always need to be on."
        ),
        tags$button(
            class="govuk-button js-cookies-submit",
            type="submit",
            "Save changes"
        )
    )
  )
}
