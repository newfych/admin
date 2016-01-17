Template.ScreensTab.helpers
  screens: ->
    Screens.find()

Template.ScreensTab.rendered = ->
  resizeElements()

Template.ScreensTab.events
  "click #screen-tab": (e, t) ->
    e.preventDefault()
    console.log 'screen tab clicked : ' + @_id
    Router.go "screen_page",
      screenId: @_id

  "click #add-screen-container": (e, t) ->
    e.preventDefault()
    bootbox.prompt
      title: "Enter Screen name"
      inputType: "text"
      buttons:
        confirm:
          label: "Submit"
      callback: (value) ->
        value and screensInsert(value)

  "click #delete": (e, t) ->
    e.preventDefault()
    console.log 'rem clicked '
    if Screens.findOne(user: Meteor.userId())
      console.log 'One found - '
      id = Screens.findOne(user: Meteor.userId())._id
      Screens.remove(id)
      console.log 'Removed ' + id

screensInsert = (val) ->
  Screens.insert
    user: Meteor.userId()
    screen: val
    console.log 'inserted ' + val + ", with id: "+ Meteor.userId()

resizeElements = ->
  screens_tab_container = $("#screens-tab-container")
  win_w = $(window).outerWidth(true)
  win_h = $(window).outerHeight(true)
  nav_h = $("#navbar").outerHeight()
  screens_tab_container_h = win_h - nav_h
  screens_tab_container.css
    position: "absolute"
    top: nav_h
    width: win_w
    height: screens_tab_container_h

