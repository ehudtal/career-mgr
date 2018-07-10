# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# tagsInput jQuery plugin: https://github.com/underovsky/jquery-tagsinput-revisited

$(document).on "turbolinks:load",  ->
  enableTagChecklistToggle = (name, listUrl, placeholder) ->
    element = $("#opportunity_#{name}_tags")
    
    if element.length
      $.get listUrl, (data) ->
        element.show();
      
        element.tagsInput
          autocomplete: {source: data}
          placeholder: placeholder
          delimiter: ";"
          validationPattern: new RegExp('^[a-zA-Z, \&/-]+$')
          onAddTag: (tag) ->
            if $(tag).hasClass('auto-refresh')
              $(tag).form().submit()
          onRemoveTag: (tag) ->
            if $(tag).hasClass('auto-refresh')
              $(tag).form().submit()

        $("a##{name}-full-list").click (event) ->
          event.preventDefault()
        
          tags = element.val().split(";")

          $(".#{name}_checkbox").each (index) ->
            if tags.includes($(this).next('label').text())
              $(this).prop("checked", true)
            else
              $(this).prop("checked", false)
      
          $("##{name}-checklist").show()
          $("##{name}-tags").hide()
    
        $("a##{name}-short-list").click (event) ->
          event.preventDefault()

          tags = []
        
          $(".#{name}_checkbox").each (index) ->
            if $(this).prop("checked")
              tags.push($(this).next('label').text())
        
          element.importTags(tags.join(';'))
        
          $("##{name}-checklist").hide()
          $("##{name}-tags").show()
          
  enableIndustryInterestTags = () ->
    element = $('#opportunity_industry_interest_tags') 
    
    if element.length
      $.get '/industries.json', (industries) ->
        $.get '/interests.json', (interests) ->
          data = $.unique(industries.concat(interests))
          
          element.show()
          
          element.tagsInput
            autocomplete: {source: data}
            placeholder: 'Add Industries/Interests'
            delimiter: ';'
            validationPattern: new RegExp('^[a-zA-Z, \&/-]+$')
            onAddTag: (tag) ->
              if $(tag).hasClass('auto-refresh')
                $(tag).form().submit()
            onRemoveTag: (tag) ->
              if $(tag).hasClass('auto-refresh')
                $(tag).form().submit()
            
        
  enableTagChecklistToggle("interest", '/interests.json', 'Add an Interest')
  enableTagChecklistToggle("industry", '/industries.json', 'Add an Industry')
  enableTagChecklistToggle("metro",    '/metros.json', 'Add a Metro')
  
  enableIndustryInterestTags()
  
  new_task_fields = () ->
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
      
  new_location_fields = () ->
    index = $('.location_fields').length
    employerId = $('.location_forms').data('employer-id')
    
    "<li class=\"location_fields removeable_fields\">
      <input type=\"hidden\" name=\"opportunity[locations_attributes][#{index}][locateable_id]\" id=\"opportunity_locations_attributes_#{index}_locateable_id\" value=\"#{employerId}\"/>
      <input type=\"hidden\" name=\"opportunity[locations_attributes][#{index}][locateable_type]\" id=\"opportunity_locations_attributes_#{index}_locateable_type\" value=\"Employer\"/>
      <div class=\"field\">
        <label for=\"opportunity_locations_attributes_#{index}_name\">Name</label><input type=\"text\" name=\"opportunity[locations_attributes][#{index}][name]\" id=\"opportunity_locations_attributes_#{index}_name\" />
        <input class=\"remove_hidden\" type=\"hidden\" value=\"false\" name=\"opportunity[locations_attributes][#{index}][_destroy]\" id=\"opportunity_locations_attributes_#{index}__destroy\" /><a class=\"remove\" href=\"#\">remove</a>
      </div>
      <div class=\"field\"><label for=\"opportunity_locations_attributes_#{index}_contact_attributes_address_1\">Address 1</label><input type=\"text\" name=\"opportunity[locations_attributes][#{index}][contact_attributes][address_1]\" id=\"opportunity_locations_attributes_#{index}_contact_attributes_address_1\" /></div>
      <div class=\"field\"><label for=\"opportunity_locations_attributes_#{index}_contact_attributes_address_2\">Address 2</label><input type=\"text\" name=\"opportunity[locations_attributes][#{index}][contact_attributes][address_2]\" id=\"opportunity_locations_attributes_#{index}_contact_attributes_address_2\" /></div>
      <div class=\"field\"><label for=\"opportunity_locations_attributes_#{index}_contact_attributes_city\">City</label><input type=\"text\" name=\"opportunity[locations_attributes][#{index}][contact_attributes][city]\" id=\"opportunity_locations_attributes_#{index}_contact_attributes_city\" /></div>
    
      <div class=\"field\">
        <label for=\"opportunity_locations_attributes_#{index}_contact_attributes_state\">State</label>
        <select name=\"opportunity[locations_attributes][#{index}][contact_attributes][state]\" id=\"opportunity_locations_attributes_#{index}_contact_attributes_state\"><option value=\"\"></option>
        <option value=\"AK\">AK</option><option value=\"AL\">AL</option><option value=\"AR\">AR</option><option value=\"AZ\">AZ</option><option value=\"CA\">CA</option><option value=\"CO\">CO</option><option value=\"CT\">CT</option><option value=\"DE\">DE</option><option value=\"FL\">FL</option>
        <option value=\"GA\">GA</option><option value=\"HI\">HI</option><option value=\"IA\">IA</option><option value=\"ID\">ID</option><option value=\"IL\">IL</option><option value=\"IN\">IN</option><option value=\"KS\">KS</option><option value=\"KY\">KY</option><option value=\"LA\">LA</option>
        <option value=\"MA\">MA</option><option value=\"MD\">MD</option><option value=\"ME\">ME</option><option value=\"MI\">MI</option><option value=\"MN\">MN</option><option value=\"MO\">MO</option><option value=\"MS\">MS</option><option value=\"MT\">MT</option><option value=\"NC\">NC</option>
        <option value=\"ND\">ND</option><option value=\"NE\">NE</option><option value=\"NH\">NH</option><option value=\"NJ\">NJ</option><option value=\"NM\">NM</option><option value=\"NV\">NV</option><option value=\"NY\">NY</option><option value=\"OH\">OH</option><option value=\"OK\">OK</option>
        <option value=\"OR\">OR</option><option value=\"PA\">PA</option><option value=\"RI\">RI</option><option value=\"SC\">SC</option><option value=\"SD\">SD</option><option value=\"TN\">TN</option><option value=\"TX\">TX</option><option value=\"UT\">UT</option><option value=\"VA\">VA</option>
        <option value=\"VT\">VT</option><option value=\"WA\">WA</option><option value=\"WI\">WI</option><option value=\"WV\">WV</option><option value=\"WY\">WY</option></select>
      </div>

      <div class=\"field\"><label for=\"opportunity_locations_attributes_#{index}_contact_attributes_postal_code\">Postal code</label><input type=\"text\" name=\"opportunity[locations_attributes][#{index}][contact_attributes][postal_code]\" id=\"opportunity_locations_attributes_#{index}_contact_attributes_postal_code\" /></div>
      <div class=\"field\"><label for=\"opportunity_locations_attributes_#{index}_contact_attributes_phone\">Phone</label><input type=\"text\" name=\"opportunity[locations_attributes][#{index}][contact_attributes][phone]\" id=\"opportunity_locations_attributes_#{index}_contact_attributes_phone\" /></div>
      <div class=\"field\"><label for=\"opportunity_locations_attributes_#{index}_contact_attributes_email\">Email</label><input type=\"text\" name=\"opportunity[locations_attributes][#{index}][contact_attributes][email]\" id=\"opportunity_locations_attributes_#{index}_contact_attributes_email\" /></div>
      <div class=\"field\"><label for=\"opportunity_locations_attributes_#{index}_contact_attributes_url\">Url</label><input type=\"text\" name=\"opportunity[locations_attributes][#{index}][contact_attributes][url]\" id=\"opportunity_locations_attributes_#{index}_contact_attributes_url\" /></div>
    </li>"

  reset_datepicker = () ->
    $('.datetime').datepicker({dateFormat: 'yy-mm-dd'})

  $('a.remove').click (event) ->
    event.preventDefault()
    
    $(this).closest('.removeable_fields').find('.remove_hidden').attr('value', '1')
    $(this).closest('.removeable_fields').hide()

  $('a.new_task').click (event) ->
    event.preventDefault()

    $('.task_forms').append(new_task_fields())
    
    reset_datepicker()

  $('a.new_location').click (event) ->
    event.preventDefault()

    $('.location_forms').append(new_location_fields())
    
    reset_datepicker()

  reset_datepicker()