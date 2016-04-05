# API

*The api is provided on json format.*

## As simple user

### Create a meeting
- route: ``POST /meetings/make.json``
- required parameters: ``meeting[name]`` (between 3-255 caractères)
- optional parameters: ``meeting[end_at]`` (parsable date) ``meeting[description]``

### Display informations about a meeting
- route: ``GET /meetings/:meeting_uuid/share.json``
- required parameters: none
- optional parameters: none

### List every meetings you own
- route: ``GET /meetings/shared.json``
- required parameters: none
- optional parameters: none

### Add a new date to one of your meetings
- route: ``PUT /meetings/:meeting_uuid/share.json``
- required parameters: ``meeting_id``
- optional parameters:  ``date[n]`` ``time[n]``

### Remove a existing date to one of your meetings
- route: ``DELETE /meetings/:meeting_uuid/share.json``
- required parameters: ``meeting_id``
- optional parameters:  none

### Add a new vote
- route: ``POST /votes``
- required parameters: ``user_date[meeting_date_id]`` ``user_date[state]``
- optional parameters:  none

### Change the state of the vote
- route: ``PATCH /votes/:id``
- required parameters: ``user_date[state]``
- optional parameters:  none
