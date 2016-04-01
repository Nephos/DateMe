# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $(document).on("ajax:success", ".meeting-maker-form-remote", (event, data, status, xhr) ->
    date = data['date'].replace("T", " ").replace(".000Z", " UTC") # it sucks TODO: remove and uniformize with Rails dates
    line = "<tr><th>#{date}</th>"
    $.each($("table thead tr:nth-child(1) td"), (e) ->
      line += "<td class='bg-danger'></td>"
    )
    line += "</tr>"
    $('table.poll tbody').append(line)
  )
