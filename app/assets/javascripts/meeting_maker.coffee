# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

insertNewInputs = (buttonSelector, idsSelector, htmlToInsert) ->
  $(document).on("click", buttonSelector, (e) ->
    id = $(idsSelector).size() + 1
    $(buttonSelector).before(htmlToInsert.replace("{{ID}}", id))
    return
  )

# Inset a new line to the table, with no reference to the database (default value: "no")
getUserDateLine = (row) ->
  user_ids = $("table.poll thead tr td").map((_, elem) -> return elem.attributes['user_id'].value)
  line = "<tr meeting_date_id='#{row['id']}'>"
  line +="<th>"
  line += "<a href=\"/meetings/#{row['id']}/share\" data-method=\"delete\" rel=\"nofollow\" class=\"btn btn-xs btn-danger\">x</a>"
  line += " #{row['date_formated']}</th>"
  line += $.map($("table thead tr:nth-child(1) td"), (idx) -> "<td class='bg-info user_date' user_date_id='' user_id='#{user_ids[idx]}'></td>").join('')
  line += "</tr>"
  return line

# Inset a new "user_date"
insertUserDate = (user_id, meeting_date_id) ->
  $.ajax(
    method: "POST",
    url: "/votes",
    data:
      user_date:
        user_id: user_id,
        meeting_date_id: meeting_date_id,
        state: 'yes'
  ).done((msg) ->
    user_date_id = msg["id"]
    offset = $("table.poll thead tr td").map((x, y) ->
      offset: x
      user_id: y.attributes.user_id.value
    ).toArray().find((x) -> return (x.user_id == user_id)).offset + 1
    cell = $("tr[meeting_date_id='#{meeting_date_id}'] td:nth-of-type(#{offset})");
    cell.attr("user_date_id", user_date_id)
    cell.removeClass("bg-info")
    cell.addClass(getHtmlClassFromState(msg['state']))
  )

# Update an "user_date" entry
updateUserDate = (user_date_id, state) ->
  $.ajax(
    method: "PATCH",
    url: "/votes/#{user_date_id}",
    data:
      user_date:
        state: state
  ).done((msg) ->
    cell = $("table.poll td[user_date_id='#{user_date_id}']")
    cell.removeClass("bg-danger")
    cell.removeClass("bg-warning")
    cell.removeClass("bg-success")
    cell.removeClass("bg-info")
    cell.addClass(getHtmlClassFromState(msg['state']))
  )

getStateFromHtml = (elem) ->
  if elem.hasClass("bg-success")
    return "yes"
  else if elem.hasClass("bg-warning")
    return "maybe"
  else if elem.hasClass("bg-danger")
    return "no"

getHtmlClassFromState = (state) ->
  if state == "yes"
    return "bg-success"
  else if state == "maybe"
    return "bg-warning"
  else if state == "no"
    return "bg-danger"

getNextState = (state) ->
  if state == "yes"
    return "maybe"
  else if state == "no"
    return "yes"
  else if state == "maybe"
    return "no"

changeUserDate = (event) ->
  user_date_id = event.target.attributes.user_date_id.value
  if user_date_id == ""
    user_id = event.target.attributes.user_id.value
    meeting_date_id = event.target.parentNode.attributes.meeting_date_id.value
    insertUserDate(user_id, meeting_date_id)
  else
    state = getStateFromHtml($("table.poll td[user_date_id='#{user_date_id}']"))
    next_state = getNextState(state)
    updateUserDate(user_date_id, next_state)

removeLineOnClick = (buttonSelector) ->
  # TODO: maybe should happend on ajax:success only ...
  $(document).on("click", buttonSelector, (event) ->
    event.target.parentNode.parentNode.remove()
  )

jQuery ->
  $(document).on("ajax:success", ".meeting-maker-form-remote", (event, data, status, xhr) ->
    # Add the lines
    lines = $("table tbody tr").toArray() # fetch all existing rows
    lines = lines.concat(data["data"].map((line) -> $(getUserDateLine(line))[0])) #  add the new generated lines
    # Sort the lines
    sorted_lines = lines.sort((a, b) -> return new Date(a.textContent.trim().replace("x ", "")) - new Date(b.textContent.trim().replace("x ", "")))
    # save the sorted rows in the html instead of the old rows
    $('table.poll tbody').html(sorted_lines.map((elem) -> return elem.outerHTML).join(""))
    # Handle errors
    $(".meeting-maker-form-remote input.form-control").map((idx, e) -> e.value = null)
    $(".page-header").before(
      "<div class=\"alert fade in alert-success \"><button data-dismiss=\"alert\" class=\"close\" type=\"button\">×</button>Inserted #{data['data'].length} new dates.</div>"
    )
    if data["errors"].length > 0
      $(".page-header").before(
        "<div class=\"alert fade in alert-danger \"><button data-dismiss=\"alert\" class=\"close\" type=\"button\">×</button>Error during insert.<br />#{data['errors'].join('<br />')}</div>"
      )
  )
  $(document).on("click", ".user_date", (event) -> changeUserDate(event))

  # this is not displayed if the current user is not the owner anyway
  insertNewInputs("#add_date", "label[for='date'] input", "<input type=\"date\" class=\"form-control input-sm\" id=\"\" name=\"date[{{ID}}]\">")
  insertNewInputs("#add_time", "label[for='time'] input", "<input type=\"time\" class=\"form-control input-sm\" id=\"\" name=\"time[{{ID}}]\">")
  removeLineOnClick("table.poll th .btn-danger")
