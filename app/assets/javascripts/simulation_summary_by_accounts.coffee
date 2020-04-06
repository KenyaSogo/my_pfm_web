# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  date_gteq_selected_value = $('#base_date_gteq').val()
  $('#base_date_gteq').val(null)
  $('#base_date_gteq').datetimepicker({
    format: 'YYYY/MM/DD',
    defaultDate: date_gteq_selected_value,
  })

  date_lteq_selected_value = $('#base_date_lteq').val()
  $('#base_date_lteq').val(null)
  $('#base_date_lteq').datetimepicker({
    format: 'YYYY/MM/DD',
    defaultDate: date_lteq_selected_value,
  })
