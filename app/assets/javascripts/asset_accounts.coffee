# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('#initial_balance_base_date').datetimepicker({
    format: 'YYYY/MM/DD',
    defaultDate: $('#initial_balance_base_date').attr('selected_value'),
  })
