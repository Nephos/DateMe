# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

insertNewInputs = (buttonSelector, idsSelector, htmlToInsert) ->
  $(document).on("click", buttonSelector, (e) ->
    id = $(idsSelector).size() + 1
    $(buttonSelector).before(htmlToInsert.replace("{{ID}}", id))
    return
  )

constructDateLine = (data, cells) ->
  line = "<tr meeting_date_id='#{data['id']}'>"
  line +="<th>"
  line += "<a href=\"/meetings/#{data['id']}/share\" data-method=\"delete\" rel=\"nofollow\" class=\"btn btn-xs btn-danger\">x</a>"
  line += " #{data['date_formated']}</th>"
  line += cells.join('')
  line += "</tr>"
  return line

# Inset a new line to the table, with no reference to the database (default value: "no")
getUserDateLine = (row) ->
  cells = $("table thead tr:nth-child(1) td").map((e, i) -> return "<td class='bg-info user_date' user_date_id='' user_id='#{e.attr('user_id')}'></td>")
  return constructDateLine(row, cells)

setCellState = (cell, state) ->
  cell.removeClass("bg-danger bg-warning bg-success bg-info")
  cell.addClass(getHtmlClassFromState(state))
  return cell

# Inset a new "user_date"
insertUserDate = (user_id, meeting_date_id) ->
  console.log("Try to create an user_date with user_id=#{user_id} and meeting_date_id=#{meeting_date_id}")
  $.ajax(
    method: "POST",
    url: "/votes",
    data:
      user_date:
        user_id: user_id,
        meeting_date_id: meeting_date_id,
        state: 'yes'
  ).success((msg) ->
    user_date_id = msg["id"]
    offset = $("table.poll thead tr td").map((x, y) ->
      offset: x
      user_id: y.attributes.user_id.value
    ).toArray().find((x) -> return (x.user_id == user_id)).offset + 1
    cell = $("tr[meeting_date_id='#{meeting_date_id}'] td[user_id='#{user_id}']");
    cell.attr("user_date_id", user_date_id)
    setCellState(cell, msg['state'])
  )

# Update an "user_date" entry
updateUserDate = (user_date_id, state) ->
  console.log("Try to update the user_date=#{user_date_id} to state=#{state}")
  $.ajax(
    method: "PATCH",
    url: "/votes/#{user_date_id}",
    data:
      user_date:
        state: state
  ).success((msg) ->
    cell = $("table.poll td[user_date_id='#{user_date_id}']")
    setCellState(cell, msg['state'])
  )

getStateFromHtml = (elem) ->
  if elem.hasClass("bg-success")
    return "yes"
  else if elem.hasClass("bg-warning")
    return "maybe"
  else if elem.hasClass("bg-danger")
    return "no"
  return ""

getHtmlClassFromState = (state) ->
  if state == "yes"
    return "bg-success"
  else if state == "maybe"
    return "bg-warning"
  else if state == "no"
    return "bg-danger"
  return "bg-info"

getNextState = (state) ->
  if state == "yes"
    return "maybe"
  else if state == "no"
    return "yes"
  else if state == "maybe"
    return "no"
  return "yes"

changeUserDate = (event) ->
  user_date_id = event.target.attributes.user_date_id
  if user_date_id
    user_date_id = user_date_id.value
  else
    user_date_id = ""

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

initTablePoll = () ->
  $.getJSON(document.URL).success((meeting) ->
    $("table.poll thead tr").html("")
    $("table.poll tbody").html("")
    thead = $.map(meeting.users, (user) -> return "<td user_id='#{user.id}'>#{user.name}</td>").join('')
    $("table.poll thead tr").append("<td></td>#{thead}")
    user_id = $("#current-user-id")[0].textContent
    has_delete_links = (user_id == "#{meeting.user_id}")
    tbody_empty_cells = meeting.users.map((e, i) -> return "<td class='user_date' user_id='#{e.id}'></td>").join('')
    tbody = meeting.dates.map((e, i) ->
      delete_link = "<a href=\"/meetings/#{meeting.uuid}/share\" data-method=\"delete\" rel=\"nofollow\" class=\"btn btn-xs btn-danger\">x</a>" if has_delete_links
      th = "<th>" + (delete_link || "") + "#{e.date_formated}" + "</th>"
      return "<tr meeting_date_id='#{e.id}'>" + th + tbody_empty_cells + "</tr>"
    ).join('')
    $("table.poll tbody").append("#{tbody}")
    meeting.subscriptions.map((user_date, i) ->
      cell = $("tr[meeting_date_id='#{user_date.meeting_date_id}'] td[user_id='#{user_date.user_id}']");
      cell[0].setAttribute("user_date_id", user_date.id) if user_date.id
      cell.addClass(getHtmlClassFromState(user_date.state))
    )
    window.tbody = tbody
    window.thead = thead
    window.user_id = user_id
    window.meeting = meeting
    return
  )


jQuery ->
  $(document).on("page:load ready", -> initTablePoll())
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
  $(document).on("page:load ready", -> $( "input[type='date']" ).datepicker(dateFormat: "yy-mm-dd"))

  # this is not displayed if the current user is not the owner anyway
  insertNewInputs("#add_date", "label[for='date'] input", "<input type=\"date\" class=\"form-control input-sm\" id=\"\" name=\"date[{{ID}}]\">")
  insertNewInputs("#add_time", "label[for='time'] input", "<input type=\"time\" class=\"form-control input-sm\" id=\"\" name=\"time[{{ID}}]\">")
  removeLineOnClick("table.poll th .btn-danger")
