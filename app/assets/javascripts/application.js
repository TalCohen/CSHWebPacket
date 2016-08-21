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

$('document').ready(function() {

  $('#toggle-talpacket').on('click', function(e) {
    var $this = $(this),
        active = $this.data('active'),
        id = $this.data('upper');

    $.ajax({
      type: "PUT",
      url: "/upperclassmen/" + id,
      data: { "active": !active },
      success: function(data) {
        $this.data('active', data);
        // Change the theme through JS
      },
      error: function(data) {
        console.log("Failed to change theme.");
      },
    });
  });

});
