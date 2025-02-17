# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  apply_from_selected_value = $('#apply_from').val()
  $('#apply_from').val(null)
  $('#apply_from').datetimepicker({
    format: 'YYYY/MM/DD',
    defaultDate: apply_from_selected_value,
  })

  apply_to_selected_value = $('#apply_to').val()
  $('#apply_to').val(null)
  $('#apply_to').datetimepicker({
    format: 'YYYY/MM/DD',
    defaultDate: apply_to_selected_value,
  })
