@ScreenEditController = RouteController.extend(
  template: "ScreenEdit"
  yieldTemplates:
    ScreenGrid:
      to: "grid"
    RightPanel:
      to: "panel"

#YIELD_TEMPLATES
	onBeforeAction: ->
		@next()

  action: ->
    if @isReady()
      @render()
    else
      @render "loading"


#ACTION_FUNCTION
  isReady: ->
    subs = [Meteor.subscribe("Screens")]
    ready = true
    _.each subs, (sub) ->
      ready = false  unless sub.ready()

    ready

  data: ->
    params: @params or {}


#DATA_FUNCTION
  onAfterAction: ->
)