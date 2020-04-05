# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  date_gteq_selected_value = $('#transaction_date_gteq').val()
  $('#transaction_date_gteq').val(null)
  $('#transaction_date_gteq').datetimepicker({
    format: 'YYYY/MM/DD',
    defaultDate: date_gteq_selected_value,
  })

  date_lteq_selected_value = $('#transaction_date_lteq').val()
  $('#transaction_date_lteq').val(null)
  $('#transaction_date_lteq').datetimepicker({
    format: 'YYYY/MM/DD',
    defaultDate: date_lteq_selected_value,
  })
