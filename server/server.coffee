verifyEmail = true
Accounts.config sendVerificationEmail: verifyEmail
Meteor.startup ->

# read environment variables from Meteor.settings
	if Meteor.settings and Meteor.settings.env and _.isObject(Meteor.settings.env)
		for variableName of Meteor.settings.env
			process.env[variableName] = Meteor.settings.env[variableName]

	#
	# Setup OAuth login service configuration (read from Meteor.settings)
	#
	# Your settings file should look like this:
	#
	# {
	#     "oauth": {
	#         "google": {
	#             "clientId": "yourClientId",
	#             "secret": "yourSecret"
	#         },
	#         "github": {
	#             "clientId": "yourClientId",
	#             "secret": "yourSecret"
	#         }
	#     }
	# }
	#
	if Accounts and Accounts.loginServiceConfiguration and Meteor.settings and Meteor.settings.oauth and _.isObject(Meteor.settings.oauth)

# google
		if Meteor.settings.oauth.google and _.isObject(Meteor.settings.oauth.google)

# remove old configuration
			Accounts.loginServiceConfiguration.remove service: "google"
			settingsObject = Meteor.settings.oauth.google
			settingsObject.service = "google"

			# add new configuration
			Accounts.loginServiceConfiguration.insert settingsObject

		# github
		if Meteor.settings.oauth.github and _.isObject(Meteor.settings.oauth.github)

# remove old configuration
			Accounts.loginServiceConfiguration.remove service: "github"
			settingsObject = Meteor.settings.oauth.github
			settingsObject.service = "github"

			# add new configuration
			Accounts.loginServiceConfiguration.insert settingsObject

		# linkedin
		if Meteor.settings.oauth.linkedin and _.isObject(Meteor.settings.oauth.linkedin)

# remove old configuration
			Accounts.loginServiceConfiguration.remove service: "linkedin"
			settingsObject = Meteor.settings.oauth.linkedin
			settingsObject.service = "linkedin"

			# add new configuration
			Accounts.loginServiceConfiguration.insert settingsObject

		# facebook
		if Meteor.settings.oauth.facebook and _.isObject(Meteor.settings.oauth.facebook)

# remove old configuration
			Accounts.loginServiceConfiguration.remove service: "facebook"
			settingsObject = Meteor.settings.oauth.facebook
			settingsObject.service = "facebook"

			# add new configuration
			Accounts.loginServiceConfiguration.insert settingsObject

		# twitter
		if Meteor.settings.oauth.twitter and _.isObject(Meteor.settings.oauth.twitter)

# remove old configuration
			Accounts.loginServiceConfiguration.remove service: "twitter"
			settingsObject = Meteor.settings.oauth.twitter
			settingsObject.service = "twitter"

			# add new configuration
			Accounts.loginServiceConfiguration.insert settingsObject

		# meteor
		if Meteor.settings.oauth.meteor and _.isObject(Meteor.settings.oauth.meteor)

# remove old configuration
			Accounts.loginServiceConfiguration.remove service: "meteor-developer"
			settingsObject = Meteor.settings.oauth.meteor
			settingsObject.service = "meteor-developer"

			# add new configuration
			Accounts.loginServiceConfiguration.insert settingsObject

Meteor.methods
	createUserAccount: (options) ->
		throw new Meteor.Error(403, "Access denied.")  unless Users.isAdmin(Meteor.userId())
		userOptions = {}
		userOptions.username = options.username  if options.username
		userOptions.email = options.email  if options.email
		userOptions.password = options.password  if options.password
		userOptions.profile = options.profile  if options.profile
		userOptions.email = options.profile.email  if options.profile and options.profile.email
		Accounts.createUser userOptions

	updateUserAccount: (userId, options) ->

# only admin or users own profile
		throw new Meteor.Error(403, "Access denied.")  unless Users.isAdmin(Meteor.userId()) or userId is Meteor.userId()

		# non-admin user can change only profile
		unless Users.isAdmin(Meteor.userId())
			keys = Object.keys(options)
			throw new Meteor.Error(403, "Access denied.")  if keys.length isnt 1 or not options.profile
		userOptions = {}
		userOptions.username = options.username  if options.username
		userOptions.email = options.email  if options.email
		userOptions.password = options.password  if options.password
		userOptions.profile = options.profile  if options.profile
		userOptions.email = options.profile.email  if options.profile and options.profile.email
		userOptions.roles = options.roles  if options.roles
		if userOptions.email
			email = userOptions.email
			delete userOptions.email

			userOptions.emails = [ address: email ]
		password = ""
		if userOptions.password
			password = userOptions.password
			delete userOptions.password
		if userOptions
			Users.update userId,
				$set: userOptions

		Accounts.setPassword userId, password  if password

	sendMail: (options) ->
		@unblock()
		Email.send options

Accounts.onCreateUser (options, user) ->
	user.roles = [ "user" ]
	user.profile = options.profile  if options.profile
	user

Accounts.validateLoginAttempt (info) ->

# reject users with role "blocked"
	throw new Meteor.Error(403, "Your account is blocked.")  if info.user and Users.isInRole(info.user._id, "blocked")
	throw new Meteor.Error(499, "E-mail not verified.")  if verifyEmail and info.user and info.user.emails and info.user.emails.length and not info.user.emails[0].verified
	true

Users.before.insert (userId, doc) ->
	if doc.emails and doc.emails[0] and doc.emails[0].address
		doc.profile = doc.profile or {}
		doc.profile.email = doc.emails[0].address
	else

# oauth
		if doc.services

# google e-mail
			if doc.services.google and doc.services.google.email
				doc.profile = doc.profile or {}
				doc.profile.email = doc.services.google.email
			else

# github e-mail
				if doc.services.github and doc.services.github.accessToken
					github = new GitHub(
						version: "3.0.0"
						timeout: 5000
					)
					github.authenticate
						type: "oauth"
						token: doc.services.github.accessToken

					try
						result = github.user.getEmails({})
						email = _.findWhere(result,
							primary: true
						)
						email = email: result[0]  if not email and result.length and _.isString(result[0])
						if email
							doc.profile = doc.profile or {}
							doc.profile.email = email.email
					catch e
						console.log e
				else

# linkedin email
					if doc.services.linkedin and doc.services.linkedin.emailAddress
						doc.profile = doc.profile or {}
						doc.profile.name = doc.services.linkedin.firstName + " " + doc.services.linkedin.lastName
						doc.profile.email = doc.services.linkedin.emailAddress
					else
						if doc.services.facebook and doc.services.facebook.email
							doc.profile = doc.profile or {}
							doc.profile.email = doc.services.facebook.email
						else
							if doc.services.twitter and doc.services.twitter.email
								doc.profile = doc.profile or {}
								doc.profile.email = doc.services.twitter.email
							else
								if doc.services["meteor-developer"] and doc.services["meteor-developer"].emails and doc.services["meteor-developer"].emails.length
									doc.profile = doc.profile or {}
									doc.profile.email = doc.services["meteor-developer"].emails[0].address

Users.before.update (userId, doc, fieldNames, modifier, options) ->
	modifier.$set.profile.email = modifier.$set.emails[0].address  if modifier.$set and modifier.$set.emails and modifier.$set.emails.length and modifier.$set.emails[0].address

Accounts.onLogin (info) ->

Accounts.urls.resetPassword = (token) ->
	Meteor.absoluteUrl "reset_password/" + token

Accounts.urls.verifyEmail = (token) ->
	Meteor.absoluteUrl "verify_email/" + token