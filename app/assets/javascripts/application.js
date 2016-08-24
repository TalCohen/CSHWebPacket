// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree 
//= require 'bootstrap.min'
//= require 'bootstrap3-typeahead.min'

var ready;
ready = function() {
  toggleTheme($('.talpacket'), $('#toggle-talpacket').data('active'));

  $('#toggle-talpacket').on('click', function(e) {
    var $this = $(this),
        active = $this.data('active'),
        id = $this.data('upper'),
        new_active = !active;

    $this.data('active', new_active);
    toggleTheme($('.talpacket'), new_active);

    $.ajax({
      type: "PUT",
      url: "/upperclassmen/" + id,
      data: { "active": new_active },
      success: function(data) {
      },
      error: function(data) {
        console.log("Failed to change theme.");
      },
    });
  });

  function toggleTheme($theme, active) {
    if (active) {
      $theme.removeClass('hidden');
      $('.default-theme').addClass('hidden');
    } else {
      $theme.addClass('hidden');
      $('.default-theme').removeClass('hidden');
    }
  }

  var $input = $('#user-search'),
      $upperclassmen = $('.search-upperclassman'),
      $freshmen = $('.search-freshman'),
      source = []

  $upperclassmen.each(function() {
    source.push({id: $(this).data('id'), name: $(this).data('name'), type: "upperclassmen"})
  });
  $freshmen.each(function() {
    source.push({id: $(this).data('id'), name: $(this).data('name'), type: "freshmen"})
  });

  $input.typeahead({source: source, autoSelect: true});
  $input.change(function() {
      var current = $input.typeahead("getActive");
      if (current) {
          // Some item from your model is active!
          if (current.name == $input.val()) {
              // This means the exact match is found. Use toLowerCase() if you want case insensitive match.
              window.location.href = "/" + current.type + "/" + current.id;
          } else {
              // This means it is only a partial match, you can either add a new item 
              // or take the active if you don't want new items
          }
      } else {
          // Nothing is active so it is a new value (or maybe empty value)
      }
  });
}

$(document).ready(ready);
$(document).on('page:load', ready);

