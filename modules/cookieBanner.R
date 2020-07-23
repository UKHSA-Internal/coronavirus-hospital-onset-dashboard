# Cookie Banner
cookieBanner <- function(id){
  tags$div(
    id = id,
    class="gem-c-cookie-banner govuk-clearfix",
    role = "region",
    "data-module" = "cookie-banner",
    "aria-label" = "cookie banner",
    style = "display: none;",
    HTML('<div class="gem-c-cookie-banner__wrapper govuk-width-container">
      <div class="govuk-grid-row">
        <div class="govuk-grid-column-two-thirds">
          <div class="gem-c-cookie-banner__message">
            <h2 class="govuk-heading-m">Tell us whether you accept cookies</h2>
            <p class="govuk-body">We use <a class="govuk-link" href="#!/cookies">cookies to collect information</a> about how you use GOV.UK. We use this information to make the website work as well as possible and improve government services.</p>
          </div>
          <div class="gem-c-cookie-banner__buttons">
            <div class="gem-c-cookie-banner__button gem-c-cookie-banner__button-accept">
              <button id="accept-cookies" class="gem-c-button govuk-button gem-c-button--inline" data-module="track-click" data-accept-cookies="true" data-track-category="cookieBanner" data-track-action="Cookie banner accepted">Accept all cookies</button>
            </div>
            <div class="gem-c-cookie-banner__button gem-c-cookie-banner__button-settings">
              <a class="gem-c-button govuk-button gem-c-button--inline govuk-!-margin-bottom-0" role="button" data-module="track-click" data-track-category="cookieBanner" data-track-action="Cookie banner settings clicked" href="#!/cookies">Set cookie preferences</a>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="gem-c-cookie-banner__confirmation govuk-width-container" tabindex="-1" style="display: none;">
      <p class="gem-c-cookie-banner__confirmation-message govuk-body">You’ve accepted all cookies. You can <a class="govuk-link" href="#!/cookies" data-module="track-click" data-track-category="cookieBanner" data-track-action="Cookie banner settings clicked from confirmation">change your cookie settings</a> at any time.</p>
      <button class="gem-c-cookie-banner__hide-button govuk-link" data-hide-cookie-banner="true" data-module="track-click" data-track-category="cookieBanner" data-track-action="Hide cookie banner">Hide</button>
    </div>')
  )
}
