# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  new_task_fields = (index) ->
    index = $('.task_fields').length
    
    "<li class=\"task_fields removeable_fields\">
        <div class=\"field\">
          <label for=\"opportunity_tasks_attributes_#{index}_name\">Name</label>
          <input type=\"text\" name=\"opportunity[tasks_attributes][#{index}][name]\" id=\"opportunity_tasks_attributes_#{index}_name\" />
        </div>
    
        <div class=\"field\">
          <label for=\"opportunity_tasks_attributes_#{index}_due_at\">Due at</label>
          <input class=\"datetime\" type=\"text\" name=\"opportunity[tasks_attributes][#{index}][due_at]\" id=\"opportunity_tasks_attributes_#{index}_due_at\" /><br>

          <input class=\"remove_hidden\" type=\"hidden\" value=\"false\" name=\"opportunity[tasks_attributes][#{index}][_destroy]\" id=\"opportunity_tasks_attributes_#{index}__destroy\" />
          <a class=\"remove\" href=\"#\">remove</a>
        </div>
      </li>"

  $('.datetime').datepicker({dateFormat: 'yy-mm-dd'})

  $('a.remove').click (event) ->
    event.preventDefault()
    
    $(this).closest('.removeable_fields').find('.remove_hidden').attr('value', '1')
    $(this).closest('.removeable_fields').hide()

  $('a.new_task').click (event) ->
    event.preventDefault()

    $('.task_fields').last().after(new_task_fields(index))
    
    $('.datetime').datepicker({dateFormat: 'yy-mm-dd'})
