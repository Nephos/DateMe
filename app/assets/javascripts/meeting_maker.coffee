# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

insertNewInputs = (buttonSelector, idsSelector, htmlToInsert) ->
  $(document).on("click", buttonSelector, (e) ->
    id = $(idsSelector).size() + 1
    $(buttonSelector).before(htmlToInsert.replace("{{ID}}", id))
    return
  )

jQuery ->
  $(document).on("ajax:success", ".meeting-maker-form-remote", (event, data, status, xhr) ->
    data.map((line) ->
      date = line['date'].replace("T", " ").replace(".000Z", " UTC") # it sucks TODO: remove and uniformize with Rails dates
      line = "<tr><th>#{date}</th>"
      $.each($("table thead tr:nth-child(1) td"), (e) ->
        line += "<td class='bg-danger'></td>"
      )
      line += "</tr>"
      $('table.poll tbody').append(line)
    )
  )

  insertNewInputs("#add_date", "label[for='date'] input", "<input type=\"date\" class=\"form-control input-sm\" id=\"\" name=\"date[{{ID}}]\">")
  insertNewInputs("#add_time", "label[for='time'] input", "<input type=\"time\" class=\"form-control input-sm\" id=\"\" name=\"time[{{ID}}]\">")
