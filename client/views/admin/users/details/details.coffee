pageSession = new ReactiveDict()

Template.AdminUsersDetailsDetailsForm.rendered = ->
	pageSession.set "adminUsersDetailsDetailsFormInfoMessage", ""
	pageSession.set "adminUsersDetailsDetailsFormErrorMessage", ""
	$(".input-group.date").each ->
		format = $(this).find("input[type='text']").attr("data-format")
		if format
			format = format.toLowerCase()
		else
			format = "mm/dd/yyyy"
		$(this).datepicker
			autoclose: true
			todayHighlight: true
			todayBtn: true
			forceParse: false
			keyboardNavigation: false
			format: format


	$("input[type='file']").fileinput()
	$("select[data-role='tagsinput']").tagsinput()
	$(".bootstrap-tagsinput").addClass "form-control"
	$("input[autofocus]").focus()

Template.AdminUsersDetailsDetailsForm.events
	submit: (e, t) ->
		submitAction = (msg) ->
			adminUsersDetailsDetailsFormMode = "read_only"
			unless t.find("#form-cancel-button")
				switch adminUsersDetailsDetailsFormMode
					when "insert"
						$(e.target)[0].reset()
					when "update"
						message = msg or "Saved."
						pageSession.set "adminUsersDetailsDetailsFormInfoMessage", message

		#SUBMIT_REDIRECT
		errorAction = (msg) ->
			msg = msg or ""
			message = msg.message or msg or "Error."
			pageSession.set "adminUsersDetailsDetailsFormErrorMessage", message
		e.preventDefault()
		pageSession.set "adminUsersDetailsDetailsFormInfoMessage", ""
		pageSession.set "adminUsersDetailsDetailsFormErrorMessage", ""
		self = this
		validateForm $(e.target), ((fieldName, fieldValue) ->
		), ((msg) ->
		), (values) ->

		false

	"click #form-cancel-button": (e, t) ->
		e.preventDefault()

#CANCEL_REDIRECT
	"click #form-close-button": (e, t) ->
		e.preventDefault()
		Router.go "admin.users", {}

	"click #form-back-button": (e, t) ->
		e.preventDefault()
		Router.go "admin.users", {}

Template.AdminUsersDetailsDetailsForm.helpers
	infoMessage: ->
		pageSession.get "adminUsersDetailsDetailsFormInfoMessage"

	errorMessage: ->
		pageSession.get "adminUsersDetailsDetailsFormErrorMessage"
