Template.ScreensTab.helpers
  screens: ->
    Screens.find()

Template.ScreensTab.events
  "click #screen-tab": (e, t) ->
    e.preventDefault()
    console.log 'screen tab clicked : ' + @_id
    Router.go "screen_page",
      screenId: @_id
  "click #add-screen": (e, t) ->
    e.preventDefault()
    Screens.insert
      user: Meteor.userId()
      screen: "main"
      console.log 'inserted' + Meteor.userId()
  "click #remove-screen": (e, t) ->
    e.preventDefault()
    console.log 'rem clicked '
    if Screens.findOne(user: Meteor.userId())
      console.log 'One found - '
      id = Screens.findOne(user: Meteor.userId())._id
      Screens.remove(id)
      console.log 'Removed ' + id
