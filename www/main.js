// Global object
let app = {};

// -----------------------------------
// A11y Tooltip plugin
// https://www.jqueryscript.net/tooltip/ARIA-Tooltip-Plugin-jQuery.html
// -----------------------------------
(function ( $, w, doc, app ) {

  // enable strict mode
  'use strict';

  app.a11yTT = {};
  var a11yTT = app.a11yTT;

  a11yTT.init = function () {

    var $ttContainer  = $('.a11y-tip');
    var ttTrigger     = '.a11y-tip__trigger';
    var ttTheTip      = '.a11y-tip__help';


    var setup = function () {

      // this will be needed for any components that don't have an ID set
      var count = 1;

      $ttContainer.each( function () {
        var $self = $(this);
        var $trigger = $self.find(ttTrigger);
        var $tip = $self.find(ttTheTip);

        // if a trigger is not an inherently focusable element, it'll need a
        // tabindex. But if it can be inherently focused, then don't set a tabindex
        if ( !$trigger.is('a') && !$trigger.is('button') && !$trigger.is('input') && !$trigger.is('textarea') && !$trigger.is('select') ) {
          $trigger.attr('tabindex', '0');
        }

        // if a tip doesn't have an ID, then we need to generate one
        if ( !$tip.attr('id') ) {
          $tip.attr('id', 'tool_tip_' + count );
        }

        // if a trigger doesn't have an aria-described by, then we need
        // to point it to the tip's ID
        if ( !$trigger.attr('aria-describedby') ) {
          $trigger.attr('aria-describedby', $tip.attr('id') );
        }

        // if the element after a tooltip trigger does not have
        // the role of tooltip set, then set it.
        if ( !$tip.attr('role') ) {
          $tip.attr('role', 'tooltip');
        }

        // end the loop, increase count by 1
        return count = count + 1;
      });

    }


    setup();

    // if a keyboard user doesn't want/need the tooltip anymore
    // allow them to hide it by pressing the ESC key.
    // once they move focus away from the element that had the
    // the tooltip, remove the hide-tip class so that the
    // tip can be accessed again on re-focus.
    $(ttTrigger).on('keydown', function ( e ) {
      var $self = $(this);

      if ( e.which == 27 ) {
        $self.parent().addClass('a11y-tip--hide');
        e.preventDefault();
        return false;
      }
    })
    .on('blur', function () {
      var $parent = $(this).parent();

      if ( $parent.hasClass('a11y-tip--hide') ) {
        $parent.removeClass('a11y-tip--hide');
      }

    });

  }; // end TT.init


  // Get this TT going!
  a11yTT.init();


})( jQuery, this, this.document, app );



// -----------------------------------
// Cookie banner
// -----------------------------------

app.cookieBanner = {
  init: function(){
    let self = this

    this.setDefaultConsentCookie()
    this.displayBannerIfPrefNotSet()
    $('#accept-cookies').click(function(){
      self.setAcceptAllCookies()
      self.setPrefsCookie()
      $('.gem-c-cookie-banner__wrapper').hide()
      $('.gem-c-cookie-banner__confirmation').show()
    })

    $('.gem-c-cookie-banner__hide-button').click(function(){
      $('#global-cookie-message').hide()
    })
  },

  setDefaultConsentCookie: function(){
    const today = new Date(),
          [year, month, day] = [today.getFullYear(), today.getMonth(), today.getDate()],
          cookieExpiryDate = new Date(year + 1, month, day).toUTCString()
    document.cookie = `cookies_policy=${encodeURIComponent('{"essential":true,"settings":false,"usage":false,"campaigns":false}')}; expires=${cookieExpiryDate};`
    //console.log('default cookie set')
  },

  displayBannerIfPrefNotSet: function(){
    let cookiePrefs = this.getCookie("cookies_preferences_set")
    if (cookiePrefs == null) {
      $('#global-cookie-message').show()
    }
  },

  setAcceptAllCookies: function(){
    let today = new Date(),
          [year, month, day] = [today.getFullYear(), today.getMonth(), today.getDate()],
          cookieExpiryDate = new Date(year + 1, month, day).toUTCString()
    document.cookie = `cookies_policy=${encodeURIComponent('{"essential":true,"settings":true,"usage":true,"campaigns":false}')}; expires=${cookieExpiryDate};`
    //console.log('accept all cookies. settings and usage flags set to true')
  },

  setPrefsCookie: function(){
    let today = new Date(),
          [year, month, day] = [today.getFullYear(), today.getMonth(), today.getDate()],
          cookieExpiryDate = new Date(year + 1, month, day).toUTCString()
    document.cookie = `cookies_preferences_set=true; expires=${cookieExpiryDate};`
    //console.log('set prefs cookie')
  },

  getCookie: function(name){
    var dc = document.cookie;
    var prefix = name + "=";
    var begin = dc.indexOf("; " + prefix);
    if (begin == -1) {
        begin = dc.indexOf(prefix);
        if (begin != 0) return null;
    }
    else
    {
        begin += 2;
        var end = document.cookie.indexOf(";", begin);
        if (end == -1) {
        end = dc.length;
        }
    }
    // because unescape has been deprecated, replaced with decodeURI
    //return unescape(dc.substring(begin + prefix.length, end));
    return decodeURI(dc.substring(begin + prefix.length, end));
  }
}


// -----------------------------------
// Run all the things
// -----------------------------------
$(function(){

  // Initialise tooltips on input update
  $(document).on('shiny:updateinput', function(event) {
    app.a11yTT.init();
  })

  // Utility to scroll top of page
  $('.js-gototop').click(function(){
    window.scrollTo(0,0);
  })

  // Initialise cookie banner
  app.cookieBanner.init();
})
