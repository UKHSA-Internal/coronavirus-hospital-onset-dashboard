/**
 * @jest-environment jsdom
 */
/* eslint-env jest */

const { axe } = require('jest-axe')

const { render, getExamples } = require('../../../../lib/jest-helpers')

const examples = getExamples('accordion')

describe('Accordion', () => {
  describe('by default', () => {
    it('passes accessibility tests', async () => {
      const $ = render('accordion', examples.default)

      const results = await axe($.html())
      expect(results).toHaveNoViolations()
    })

    it('renders with specified heading level', () => {
      const $ = render('accordion', {
        headingLevel: '3',
        items: [
          {
            heading: {
              text: 'Section A'
            },
            content: {
              text: 'Some content'
            }
          }
        ]
      })
      const $componentHeading = $('.govuk-accordion__section-heading')

      expect($componentHeading.get(0).tagName).toEqual('h3')
    })

    it('renders with heading button text', () => {
      const $ = render('accordion', {
        headingLevel: '3',
        items: [
          {
            heading: {
              html: '<span class="myClass">Section A</span>'
            },
            content: {
              text: 'Some content'
            }
          }
        ]
      })
      const $componentHeadingButton = $('.govuk-accordion__section-button')

      expect($componentHeadingButton.html().trim()).toEqual('<span class="myClass">Section A</span>')
    })

    it('renders with content', () => {
      const $ = render('accordion', {
        headingLevel: '3',
        items: [
          {
            heading: {
              text: 'Section A'
            },
            content: {
              text: 'Some content'
            }
          }
        ]
      })
      const $componentContent = $('.govuk-accordion__section-content')

      expect($componentContent.text().trim()).toEqual('Some content')
    })

    it('renders list without falsely values', () => {
      const $ = render('accordion', {
        headingLevel: '3',
        items: [
          {
            heading: {
              text: 'Section A'
            },
            content: {
              text: 'Some content'
            }
          },
          false,
          undefined,
          null,
          {
            heading: {
              text: 'Section B'
            },
            content: {
              text: 'Some content'
            }
          }
        ]
      })
      const $component = $('.govuk-accordion')
      const $items = $component.find('.govuk-accordion__section')

      expect($items.length).toEqual(2)
    })

    it('renders with classes', () => {
      const $ = render('accordion', {
        classes: 'app-accordion--custom-modifier'
      })

      const $component = $('.govuk-accordion')
      expect($component.hasClass('app-accordion--custom-modifier')).toBeTruthy()
    })

    it('renders with id', () => {
      const $ = render('accordion', {
        id: 'my-accordion'
      })

      const $component = $('.govuk-accordion')
      expect($component.attr('id')).toEqual('my-accordion')
    })

    it('renders with attributes', () => {
      const $ = render('accordion', {
        attributes: {
          'data-attribute': 'my data value'
        }
      })
      const $component = $('.govuk-accordion')
      expect($component.attr('data-attribute')).toEqual('my data value')
    })

    it('renders with section expanded class', () => {
      const $ = render('accordion', {
        items: [
          {
            expanded: true,
            heading: {
              text: 'Section A'
            },
            content: {
              text: 'Some content'
            }
          }
        ]
      })
      const $componentSection = $('.govuk-accordion__section')

      expect($componentSection.hasClass('govuk-accordion__section--expanded')).toBeTruthy()
    })

    describe('when it includes a summary', () => {
      it('renders with summary', () => {
        const $ = render('accordion', {
          headingLevel: '3',
          items: [
            {
              heading: {
                text: 'Section A'
              },
              summary: {
                text: 'Summary of content'
              },
              content: {
                text: 'Some content'
              }
            }
          ]
        })
        const $componentSummary = $('.govuk-accordion__section-summary')

        expect($componentSummary.text().trim()).toEqual('Summary of content')
      })
    })
  })
})
