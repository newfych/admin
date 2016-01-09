Screens.allow
	insert: (userId, doc) ->
		!! userId

	update: (userId, doc) ->
		!! userId

	remove: (userId, doc) ->
		!! userId

Meteor.publish "Screens", ->
	return []  unless @userId
	Screens.find user: @userId
