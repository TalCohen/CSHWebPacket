# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('#freshmen').click (e) ->
    e.preventDefault()
    $(this).addClass('active')
    $(this).removeClass('btn-default')
    $(this).addClass('btn-primary')
    $('#upperclassmen').removeClass('active')
    $('#upperclassmen').removeClass('btn-primary')
    $('#upperclassmen').addClass('btn-default')
    $('#freshTable').removeClass('hidden')
    $('#upperTable').addClass('hidden')


  $('#upperclassmen').click (e) ->
    e.preventDefault()
    $(this).addClass('active')
    $(this).removeClass('btn-default')
    $(this).addClass('btn-primary')
    $('#freshmen').removeClass('active')
    $('#freshmen').removeClass('btn-primary')
    $('#freshmen').addClass('btn-default')
    $('#upperTable').removeClass('hidden')
    $('#freshTable').addClass('hidden')

$(document).ready(ready)
$(document).on('page:load', ready)
