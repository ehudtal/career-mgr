# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  enableEmployerTagChecklistToggle = (element, listUrl, placeholder) ->
    if $("#employer_#{element}_tags").length
      $.get listUrl, (data) ->
        $("#employer_#{element}_tags").show();
      
        $("#employer_#{element}_tags").tagsInput
          autocomplete: {source: data}
          placeholder: placeholder
          delimiter: ";"
          validationPattern: new RegExp('^[a-zA-Z, \&/-]+$')

        $("a##{element}-full-list").click (event) ->
          event.preventDefault()
        
          tags = $("#employer_#{element}_tags").val().split(";")

          $(".#{element}_checkbox").each (index) ->
            if tags.includes($(this).next('label').text())
              $(this).prop("checked", true)
            else
              $(this).prop("checked", false)
      
          $("##{element}-checklist").show()
          $("##{element}-tags").hide()
    
        $("a##{element}-short-list").click (event) ->
          event.preventDefault()

          tags = []
        
          $(".#{element}_checkbox").each (index) ->
            if $(this).prop("checked")
              tags.push($(this).next('label').text())
        
          $("#employer_#{element}_tags").importTags(tags.join(';'))
        
          $("##{element}-checklist").hide()
          $("##{element}-tags").show()

        
  enableEmployerTagChecklistToggle("industry", '/industries.json', 'Add an Industry')
