# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load",  ->
  $('input.career[type=checkbox]').click (event) ->
    $(event.target).form().submit()
    
    checkboxes = 'form.career-tracker-form input.career[type="checkbox"]'

    if $(checkboxes).length == $(checkboxes + ':checked').length
      $('#career-progress').addClass('all-done')
    else
      $('#career-progress').removeClass('all-done')
      
    
  $('form.career-tracker-form').submit (event) ->
    event.preventDefault()
    
    $.ajax({
      type: 'POST',
      url: this.action,
      data: $(this).serialize(),
      success: () ->
        console.log('career steps have been updated.')
    })