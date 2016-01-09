@AdminUsersController = RouteController.extend(
	template: "Admin"
	yieldTemplates:
		AdminUsers:
			to: "AdminSubcontent"

	onBeforeAction: ->
		@next()

	action: ->
		if @isReady()
			@render()
		else
			@render "Admin"
			@render "loading",
				to: "AdminSubcontent"



#ACTION_FUNCTION
	isReady: ->
		subs = [ Meteor.subscribe("admin_users") ]
		ready = true
		_.each subs, (sub) ->
			ready = false  unless sub.ready()

		ready

	data: ->
		params: @params or {}
		admin_users: Users.find({}, {})


#DATA_FUNCTION
	onAfterAction: ->
)