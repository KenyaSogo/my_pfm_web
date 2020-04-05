# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  base_date_selected_value = $('#initial_balance_base_date').val()
  $('#initial_balance_base_date').val(null)
  $('#initial_balance_base_date').datetimepicker({
    format: 'YYYY/MM/DD',
    defaultDate: base_date_selected_value,
  })
