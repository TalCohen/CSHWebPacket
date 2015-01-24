# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('#signatures').click (e) ->
    e.preventDefault()
    $(this).addClass('active')
    $(this).removeClass('btn-default')
    $(this).addClass('btn-primary')
    $('#packet').removeClass('active')
    $('#packet').removeClass('btn-primary')
    $('#packet').addClass('btn-default')
    $('#signaturesTable').removeClass('hidden')
    $('#packetTable').addClass('hidden')

  $('#packet').click (e) ->
    e.preventDefault()
    $(this).addClass('active')
    $(this).removeClass('btn-default')
    $(this).addClass('btn-primary')
    $('#signatures').removeClass('active')
    $('#signatures').removeClass('btn-primary')
    $('#signatures').addClass('btn-default')
    $('#packetTable').removeClass('hidden')
    $('#signaturesTable').addClass('hidden')

### Finished packets
  $('#finished').click (e) ->
    e.preventDefault()
    $(this).addClass('active')
    $(this).removeClass('btn-default')
    $(this).addClass('btn-primary')
    $('#doing').removeClass('active')
    $('#doing').removeClass('btn-primary')
    $('#doing').addClass('btn-default')
    $('#finishedTable').removeClass('hidden')
    $('#doingTable').addClass('hidden')

  $('#doing').click (e) ->
    e.preventDefault()
    $(this).addClass('active')
    $(this).removeClass('btn-default')
    $(this).addClass('btn-primary')
    $('#finished').removeClass('active')
    $('#finished').removeClass('btn-primary')
    $('#finished').addClass('btn-default')
    $('#doingTable').removeClass('hidden')
    $('#finishedTable').addClass('hidden')
###

$(document).ready(ready)
$(document).on('page:load', ready)
