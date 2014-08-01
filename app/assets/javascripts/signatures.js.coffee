# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('#freshmen').click (e) ->
    e.preventDefault()
    $(this).addClass('active')
    $('#upperclassmen').removeClass('active')
    $('#freshTable').removeClass('hidden')
    $('#upperTable').addClass('hidden')


  $('#upperclassmen').click (e) ->
    e.preventDefault()
    $(this).addClass('active')
    $('#freshmen').removeClass('active')
    $('#upperTable').removeClass('hidden')
    $('#freshTable').addClass('hidden')

