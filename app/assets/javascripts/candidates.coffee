# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load",  ->
  $.tablesorter.addParser
    id: 'semester'
    is: (s) -> false
    format: (s) ->
      semesters = ['Q3', 'Q4', 'Fall', 'Q1', 'Q2', 'Spring']
      words = $.trim(s).split(/\s+/)
      
      parseInt(words[1]) * 100 + semesters.indexOf(words[0])
    type: 'numeric'

  $.tablesorter.addParser
    id: 'labelled'
    is: (s) -> false
    format: (s) -> parseFloat(s)
    type: 'numeric'

  $.tablesorter.addParser
    id: 'employment status'
    is: (s) -> false
    format: (s) -> 
      statuses = ['Unemployed', 'Not Quality', 'Part Quality', 'Service', 'Quality (Grad School)', 'Quality', 'Unknown']
      statuses.indexOf(s)
    type: 'numeric'
  
  $('#candidate-list').tablesorter({
    headers: {
      0: {sorter: false},
      2: {sorter: 'semester'}
      5: {sorter: false},
      6: {sorter: false},
      7: {sorter: false},
      8: {sorter: 'labelled'},
      9: {sorter: 'employment status'},
      10: {sorter: false}
    }
  })
  
  $('#advanced-search-toggle a').click (event) ->
    event.preventDefault()
    
    if /show/.test($(this).text())
      $(this).text('- hide advanced search')
      $('#advanced-search').show();
    else
      $(this).text('+ show advanced search')
      $('#advanced-search').hide();
  