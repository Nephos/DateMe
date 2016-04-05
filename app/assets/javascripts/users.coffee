# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on("keyup", ".user-uuid-find input", (event) ->
  uuid = event.target.value.trim()
  $(".user-uuid-find").attr("action", "/users/uuid/#{uuid}")
)
