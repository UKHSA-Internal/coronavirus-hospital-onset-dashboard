/**
 * @jest-environment jsdom
 */
/* eslint-env jest */

const axe = require('../../../../lib/axe-helper')

const { render, getExamples } = require('../../../../lib/jest-helpers')

const examples = getExamples('error-summary')

describe('Error-summary', () => {
  it('default example passes accessibility tests', async () => {
    const $ = render('error-summary', examples.default)

    const results = await axe($.html())
    expect(results).toHaveNoViolations()
  })

  it('aria-labelledby attribute matches the title id', () => {
    const $ = render('error-summary', examples.default)
    const ariaAttr = $('.govuk-error-summary').attr('aria-labelledby')

    expect(ariaAttr).toEqual('error-summary-title')
  })

  it('has role=alert attribute', () => {
    const $ = render('error-summary', examples.default)
    const roleAttr = $('.govuk-error-summary').attr('role')

    expect(roleAttr).toEqual('alert')
  })

  it('has the correct tabindex attribute to be focussed', () => {
    const $ = render('error-summary', examples.default)
    const tabindexAttr = $('.govuk-error-summary').attr('tabindex')

    expect(tabindexAttr).toEqual('-1')
  })

  it('renders title text', () => {
    const $ = render('error-summary', examples.default)
    const summaryTitle = $('.govuk-error-summary__title').text().trim()

    expect(summaryTitle).toEqual('There is a problem')
  })

  it('allows title text to be passed whilst escaping HTML entities', () => {
    const $ = render('error-summary', {
      titleText: 'Alert, <em>alert</em>'
    })

    const summaryTitle = $('.govuk-error-summary__title').html().trim()
    expect(summaryTitle).toEqual('Alert, &lt;em&gt;alert&lt;/em&gt;')
  })

  it('allows title HTML to be passed un-escaped', () => {
    const $ = render('error-summary', {
      titleHtml: 'Alert, <em>alert</em>'
    })

    const summaryTitle = $('.govuk-error-summary__title').html().trim()
    expect(summaryTitle).toEqual('Alert, <em>alert</em>')
  })

  it('renders description text', () => {
    const $ = render('error-summary', {
      descriptionText: 'Lorem ipsum'
    })
    const summaryDescription = $('.govuk-error-summary__body p').text().trim()

    expect(summaryDescription).toEqual('Lorem ipsum')
  })

  it('allows description text to be passed whilst escaping HTML entities', () => {
    const $ = render('error-summary', {
      descriptionText: 'See errors below (▼)'
    })

    const summaryDescription = $('.govuk-error-summary__body p').html().trim()
    expect(summaryDescription).toEqual('See errors below (&#x25BC;)')
  })

  it('allows description HTML to be passed un-escaped', () => {
    const $ = render('error-summary', {
      descriptionHtml: 'See <span>errors</span> below'
    })

    const summaryDescription = $('.govuk-error-summary__body p').html().trim()
    expect(summaryDescription).toEqual('See <span>errors</span> below')
  })

  it('allows additional classes to be added to the error-summary component', () => {
    const $ = render('error-summary', {
      classes: 'extra-class one-more-class'
    })

    const $component = $('.govuk-error-summary')
    expect($component.hasClass('extra-class one-more-class')).toBeTruthy()
  })

  it('allows additional attributes to be added to the error-summary component', () => {
    const $ = render('error-summary', {
      attributes: {
        'first-attribute': 'true',
        'second-attribute': 'false'
      }
    })

    const $component = $('.govuk-error-summary')
    expect($component.attr('first-attribute')).toEqual('true')
    expect($component.attr('second-attribute')).toEqual('false')
  })

  it('number of error items matches the number of items specified', () => {
    const $ = render('error-summary', examples.default)
    const errorList = $('.govuk-error-summary .govuk-error-summary__list li')

    expect(errorList).toHaveLength(2)
  })

  it('error list item is an anchor tag if href attribute is specified', () => {
    const $ = render('error-summary', examples.default)

    const errorItem = $('.govuk-error-summary .govuk-error-summary__list li:first-child')
    expect(errorItem.children().get(0).tagName).toEqual('a')
  })

  it('render anchor tag href attribute is correctly', () => {
    const $ = render('error-summary', examples.default)

    const errorItem = $('.govuk-error-summary .govuk-error-summary__list li:first-child a')
    expect(errorItem.attr('href')).toEqual('#example-error-1')
  })

  it('renders anchor tag with attributes', () => {
    const $ = render('error-summary', {
      errorList: [
        {
          text: 'Error-1',
          href: '#item',
          attributes: {
            'data-attribute': 'my-attribute',
            'data-attribute-2': 'my-attribute-2'
          }
        }
      ]
    })

    const $component = $('.govuk-error-summary__list a')
    expect($component.attr('data-attribute')).toEqual('my-attribute')
    expect($component.attr('data-attribute-2')).toEqual('my-attribute-2')
  })

  it('renders error item text', () => {
    const $ = render('error-summary', examples.default)
    const errorItemText = $('.govuk-error-summary .govuk-error-summary__list li:first-child').text().trim()

    expect(errorItemText).toEqual('The date your passport was issued must be in the past')
  })

  it('allows error item HTML to be passed un-escaped', () => {
    const $ = render('error-summary', {
      errorList: [
        {
          html: 'The date your passport was issued <b>must</b> be in the past'
        }
      ]
    })

    const errorItemText = $('.govuk-error-summary .govuk-error-summary__list li').html().trim()

    expect(errorItemText).toEqual('The date your passport was issued <b>must</b> be in the past')
  })

  it('allows error item text to be passed whilst escaping HTML entities', () => {
    const $ = render('error-summary', {
      errorList: [
        {
          text: 'Descriptive link to the <b>question</b> with an error'
        }
      ]
    })

    const errorItemText = $('.govuk-error-summary .govuk-error-summary__list li').html().trim()

    expect(errorItemText).toEqual('Descriptive link to the &lt;b&gt;question&lt;/b&gt; with an error')
  })

  it('allows error item HTML inside "a" tag to be passed un-escaped', () => {
    const $ = render('error-summary', {
      errorList: [
        {
          html: 'Descriptive link to the <b>question</b> with an error',
          href: '#error-1'
        }
      ]
    })

    const errorItemText = $('.govuk-error-summary .govuk-error-summary__list li a').html().trim()

    expect(errorItemText).toEqual('Descriptive link to the <b>question</b> with an error')
  })

  it('allows error item text inside "a" tag to be passed whilst escaping HTML entities', () => {
    const $ = render('error-summary', {
      errorList: [
        {
          text: 'Descriptive link to the <b>question</b> with an error',
          href: '#error-1'
        }
      ]
    })

    const errorItemText = $('.govuk-error-summary .govuk-error-summary__list li a').html().trim()

    expect(errorItemText).toEqual('Descriptive link to the &lt;b&gt;question&lt;/b&gt; with an error')
  })
})
