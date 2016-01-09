Template.ScreensTab.helpers
  screens: ->
    Screens.find()

Template.ScreensTab.events
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

#Template.ScreensTab.rendered = ->
#  screens = ->
#    Screens.find
#      user: Meteor.userId()
#      , {}
#  console.log screens