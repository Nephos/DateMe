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
addUserDateLine = (row) ->
  user_ids = $("table.poll thead tr td").map((_, elem) -> return elem.attributes['user_id'].value)
  date = row['date'].replace("T", " ").replace(".000Z", " UTC") # it sucks TODO: remove and uniformize with Rails dates
  line = "<tr meeting_date_id='#{row['id']}'>"
  line +="<th>"
  line += "<a href=\"/meetings/#{row['id']}/share\" data-method=\"delete\" rel=\"nofollow\" class=\"btn btn-xs btn-danger\">x</a>"
  line += " #{date}</th>"
  $.each($("table thead tr:nth-child(1) td"), (idx) -> line += "<td class='bg-danger user_date' user_date_id='' user_id='#{user_ids[idx]}'></td>")
  line += "</tr>"
  $('table.poll tbody').append(line)

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
    cell.removeClass("bg-danger")
    cell.addClass("bg-success")
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
    $("table.poll td[user_date_id='#{user_date_id}']").removeClass("bg-danger")
    $("table.poll td[user_date_id='#{user_date_id}']").removeClass("bg-warning")
    $("table.poll td[user_date_id='#{user_date_id}']").removeClass("bg-success")
    $("table.poll td[user_date_id='#{user_date_id}']").addClass(getHtmlClassFromState(state))
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
    return "no"
  else if state == "no"
    return "maybe"
  else if state == "maybe"
    return "yes"

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

jQuery ->
  $(document).on("ajax:success", ".meeting-maker-form-remote", (event, data, status, xhr) ->
    data.map((line) -> addUserDateLine(line))
  )
  $(document).on("click", ".user_date", (event) -> changeUserDate(event))

  insertNewInputs("#add_date", "label[for='date'] input", "<input type=\"date\" class=\"form-control input-sm\" id=\"\" name=\"date[{{ID}}]\">")
  insertNewInputs("#add_time", "label[for='time'] input", "<input type=\"time\" class=\"form-control input-sm\" id=\"\" name=\"time[{{ID}}]\">")
