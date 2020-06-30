/**
 * @jest-environment jsdom
 */
/* eslint-env jest */

const axe = require('../../../../lib/axe-helper')

const { render, getExamples, htmlWithClassName } = require('../../../../lib/jest-helpers')

const examples = getExamples('textarea')

const WORD_BOUNDARY = '\\b'
const WHITESPACE = '\\s'

describe('Textarea', () => {
  describe('by default', () => {
    it('passes accessibility tests', async () => {
      const $ = render('textarea', examples.default)

      const results = await axe($.html())
      expect(results).toHaveNoViolations()
    })

    it('renders with classes', () => {
      const $ = render('textarea', {
        classes: 'app-textarea--custom-modifier'
      })

      const $component = $('.govuk-textarea')
      expect($component.hasClass('app-textarea--custom-modifier')).toBeTruthy()
    })

    it('renders with id', () => {
      const $ = render('textarea', {
        id: 'my-textarea'
      })

      const $component = $('.govuk-textarea')
      expect($component.attr('id')).toEqual('my-textarea')
    })

    it('renders with name', () => {
      const $ = render('textarea', {
        name: 'my-textarea-name'
      })

      const $component = $('.govuk-textarea')
      expect($component.attr('name')).toEqual('my-textarea-name')
    })

    it('renders with aria-describedby', () => {
      const describedById = 'some-id'

      const $ = render('textarea', {
        describedBy: describedById
      })

      const $component = $('.govuk-textarea')
      expect($component.attr('aria-describedby')).toMatch(describedById)
    })

    it('renders with rows', () => {
      const $ = render('textarea', {
        rows: '4'
      })

      const $component = $('.govuk-textarea')
      expect($component.attr('rows')).toEqual('4')
    })

    it('renders with default number of rows', () => {
      const $ = render('textarea', {})

      const $component = $('.govuk-textarea')
      expect($component.attr('rows')).toEqual('5')
    })

    it('renders with value', () => {
      const $ = render('textarea', {
        value: '221B Baker Street\nLondon\nNW1 6XE\n'
      })

      const $component = $('.govuk-textarea')
      expect($component.text()).toEqual('221B Baker Street\nLondon\nNW1 6XE\n')
    })

    it('renders with attributes', () => {
      const $ = render('textarea', {
        attributes: {
          'data-attribute': 'my data value'
        }
      })

      const $component = $('.govuk-textarea')
      expect($component.attr('data-attribute')).toEqual('my data value')
    })

    it('renders with a form group wrapper', () => {
      const $ = render('textarea', {})

      const $formGroup = $('.govuk-form-group')
      expect($formGroup.length).toBeTruthy()
    })
  })

  describe('when it includes a hint', () => {
    it('renders with hint', () => {
      const $ = render('textarea', {
        id: 'textarea-with-error',
        hint: {
          text: 'It’s on your National Insurance card, benefit letter, payslip or P60. For example, ‘QQ 12 34 56 C’.'
        }
      })

      expect(htmlWithClassName($, '.govuk-hint')).toMatchSnapshot()
    })

    it('associates the textarea as "described by" the hint', () => {
      const $ = render('textarea', {
        id: 'textarea-with-error',
        hint: {
          text: 'It’s on your National Insurance card, benefit letter, payslip or P60. For example, ‘QQ 12 34 56 C’.'
        }
      })

      const $textarea = $('.govuk-textarea')
      const $hint = $('.govuk-hint')

      const hintId = new RegExp(
        WORD_BOUNDARY + $hint.attr('id') + WORD_BOUNDARY
      )

      expect($textarea.attr('aria-describedby'))
        .toMatch(hintId)
    })

    it('associates the textarea as "described by" the hint and parent fieldset', () => {
      const describedById = 'some-id'

      const $ = render('textarea', {
        id: 'textarea-with-error',
        describedBy: describedById,
        hint: {
          text: 'It’s on your National Insurance card, benefit letter, payslip or P60. For example, ‘QQ 12 34 56 C’.'
        }
      })

      const $textarea = $('.govuk-textarea')
      const $hint = $('.govuk-hint')

      const hintId = new RegExp(
        WORD_BOUNDARY + describedById + WHITESPACE + $hint.attr('id') + WORD_BOUNDARY
      )

      expect($textarea.attr('aria-describedby'))
        .toMatch(hintId)
    })
  })

  describe('when it includes an error message', () => {
    it('renders with error message', () => {
      const $ = render('textarea', {
        id: 'textarea-with-error',
        errorMessage: {
          text: 'Error message'
        }
      })

      expect(htmlWithClassName($, '.govuk-error-message')).toMatchSnapshot()
    })

    it('associates the textarea as "described by" the error message', () => {
      const $ = render('textarea', {
        id: 'textarea-with-error',
        errorMessage: {
          text: 'Error message'
        }
      })

      const $component = $('.govuk-textarea')
      const $errorMessage = $('.govuk-error-message')

      const errorMessageId = new RegExp(
        WORD_BOUNDARY + $errorMessage.attr('id') + WORD_BOUNDARY
      )

      expect($component.attr('aria-describedby'))
        .toMatch(errorMessageId)
    })

    it('associates the textarea as "described by" the error message and parent fieldset', () => {
      const describedById = 'some-id'

      const $ = render('textarea', {
        id: 'textarea-with-error',
        describedBy: describedById,
        errorMessage: {
          text: 'Error message'
        }
      })

      const $component = $('.govuk-textarea')
      const $errorMessage = $('.govuk-error-message')

      const errorMessageId = new RegExp(
        WORD_BOUNDARY + describedById + WHITESPACE + $errorMessage.attr('id') + WORD_BOUNDARY
      )

      expect($component.attr('aria-describedby'))
        .toMatch(errorMessageId)
    })

    it('adds the error class to the textarea', () => {
      const $ = render('textarea', {
        errorMessage: {
          text: 'Error message'
        }
      })

      const $component = $('.govuk-textarea')
      expect($component.hasClass('govuk-textarea--error')).toBeTruthy()
    })

    it('renders with a form group wrapper that has extra classes', () => {
      const $ = render('textarea', {
        formGroup: {
          classes: 'extra-class'
        }
      })

      const $formGroup = $('.govuk-form-group')
      expect($formGroup.hasClass('extra-class')).toBeTruthy()
    })

    it('renders with a form group wrapper that has an error state', () => {
      const $ = render('textarea', {
        errorMessage: {
          text: 'Error message'
        }
      })

      const $formGroup = $('.govuk-form-group')
      expect($formGroup.hasClass('govuk-form-group--error')).toBeTruthy()
    })
  })

  describe('when it includes both a hint and an error message', () => {
    it('associates the textarea as described by both the hint and the error message', () => {
      const $ = render('textarea', {
        errorMessage: {
          text: 'Error message'
        },
        hint: {
          text: 'Hint'
        }
      })

      const $component = $('.govuk-textarea')
      const errorMessageId = $('.govuk-error-message').attr('id')
      const hintId = $('.govuk-hint').attr('id')

      const combinedIds = new RegExp(
        WORD_BOUNDARY + hintId + WHITESPACE + errorMessageId + WORD_BOUNDARY
      )

      expect($component.attr('aria-describedby'))
        .toMatch(combinedIds)
    })

    it('associates the textarea as described by the hint, error message and parent fieldset', () => {
      const describedById = 'some-id'

      const $ = render('textarea', {
        describedBy: describedById,
        errorMessage: {
          text: 'Error message'
        },
        hint: {
          text: 'Hint'
        }
      })

      const $component = $('.govuk-textarea')
      const errorMessageId = $('.govuk-error-message').attr('id')
      const hintId = $('.govuk-hint').attr('id')

      const combinedIds = new RegExp(
        WORD_BOUNDARY + describedById + WHITESPACE + hintId + WHITESPACE + errorMessageId + WORD_BOUNDARY
      )

      expect($component.attr('aria-describedby'))
        .toMatch(combinedIds)
    })
  })

  describe('with dependant components', () => {
    it('have correct nesting order', () => {
      const $ = render('textarea', {
        id: 'nested-order',
        label: {
          text: 'Full address'
        },
        errorMessage: {
          text: 'Error message'
        }
      })

      const $component = $('.govuk-form-group > .govuk-textarea')
      expect($component.length).toBeTruthy()
    })

    it('renders with label', () => {
      const $ = render('textarea', {
        id: 'my-textarea',
        label: {
          text: 'Full address'
        }
      })

      expect(htmlWithClassName($, '.govuk-label')).toMatchSnapshot()
    })

    it('renders label with "for" attribute reffering the textarea "id"', () => {
      const $ = render('textarea', {
        id: 'my-textarea',
        label: {
          text: 'Full address'
        }
      })

      const $label = $('.govuk-label')
      expect($label.attr('for')).toEqual('my-textarea')
    })
  })

  describe('when it includes an autocomplete attribute', () => {
    it('renders the autocomplete attribute', () => {
      const $ = render('textarea', {
        attributes: {
          autocomplete: 'street-address'
        }
      })

      const $component = $('.govuk-textarea')
      expect($component.attr('autocomplete')).toEqual('street-address')
    })
  })
})
