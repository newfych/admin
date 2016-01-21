Controls.allow
  insert: (userId, doc) ->
    !! userId

  update: (userId, doc) ->
    !! userId

  remove: (userId, doc) ->
    !! userId

Meteor.publish "Controls", ->
  return []  unless @userId
  Controls.find user: @userId