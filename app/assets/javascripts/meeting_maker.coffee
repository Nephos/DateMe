# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

insertNewInputs = (buttonSelector, idsSelector, htmlToInsert) ->
  $(document).on("click", buttonSelector, (e) ->
    id = $(idsSelector).size() + 1
    $(buttonSelector).before(htmlToInsert.replace("{{ID}}", id))
    return
  )

addUserDateLine = (line) ->
  user_ids = $("thead tr td").map((_, elem) -> return elem.attributes['user_id'].value)
  date = line['date'].replace("T", " ").replace(".000Z", " UTC") # it sucks TODO: remove and uniformize with Rails dates
  line = "<tr meeting_date_id='#{line['id']}'><th>#{date}</th>"
  $.each($("table thead tr:nth-child(1) td"), (idx) ->
    line += "<td class='bg-danger user_date' user_date_id='' user_id='#{user_ids[idx]}'></td>"
  )
  line += "</tr>"
  $('table.poll tbody').append(line)

updateUserDate = (event) ->
  console.log(event)
  event.target.parentNode.attributes['meeting_date_id'].value
  document.s = event

jQuery ->
  $(document).on("ajax:success", ".meeting-maker-form-remote", (event, data, status, xhr) ->
    data.map((line) ->
      addUserDateLine(line)
    )
  )
  $(document).on("click", ".user_date", (event) ->
    updateUserDate(event)
  )

  insertNewInputs("#add_date", "label[for='date'] input", "<input type=\"date\" class=\"form-control input-sm\" id=\"\" name=\"date[{{ID}}]\">")
  insertNewInputs("#add_time", "label[for='time'] input", "<input type=\"time\" class=\"form-control input-sm\" id=\"\" name=\"time[{{ID}}]\">")
