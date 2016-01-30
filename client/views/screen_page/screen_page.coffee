Template.ScreenPage.helpers
  currentId: ->
    currentId()
  currentScreen: ->
    currentScreen()

Template.PrivateLayout.events
  "click #edit": (e, t) ->
    e.preventDefault()
    console.log 'edit clicked : ' + currentId()
    Router.go "screen_edit",
      screenId: currentId()
  "click #delete": (e, t) ->
    e.preventDefault()
    console.log 'rem clicked '
    if Screens.findOne( _id: currentId())
      bootbox.dialog
        title: "Delete screen"
        message: "Are you sure to delete this screen?"
        buttons:
          confirm:
            label: "Delete"
            className: "btn-warning"
            callback: ->
              console.log 'One found - '
              Screens.remove( _id: currentId())
              console.log 'Removed ' + currentId()
              Router.go "home_private"
          danger:
            label: "Cancel"
            className: "btn-default"

Template.ScreenPage.events
  "click #smart-button": (e, t) ->
    bootbox.dialog
      message: "Select an option"
#      title: "Custom title"
      buttons:
        home:
          label: "Home"
          className: "btn-default form-control"
          callback: ->
            Router.go "home_private"

        edit:
          label: "Edit"
          className: "btn-default form-control"
          callback: ->
            Router.go "screen_edit",
              screenId: currentId()

        cancel:
          label: "Cancel"
          className: "btn-primary form-control"
          callback: ->
            console.log 'Cancel'


Template.ScreenPage.created = ->
  hideNavbar()

Template.ScreenPage.rendered = ->
  resizeElements()
#  updateNavbar()

currentId = ->
  Router.current().params.screenId

currentScreen = ->
  screen = Screens.findOne({_id: currentId()}, {})
  return screen and screen.screen

hideNavbar = ->
    $("#navbar").hide()

#updateNavbar = ->
#  left_menu = $("#private-left-menu-items")
#  left_menu.append(
#    '<li id="screen-page-navbar-element"><a href="#" id="edit">
#    <span class="item-title">&nbsp;Edit</span>
#    </a></li>')
#  left_menu.append(
#    '<li id="screen-page-navbar-element"><a href="#" id="rename">
#    <span class="item-title">&nbsp;Rename</span>
#    </a></li>')
#  left_menu.append(
#    '<li id="screen-page-navbar-element"><a href="#" id="delete">
#    <span class="item-title">&nbsp;Delete</span>
#    </a></li>')

resizeElements = ->
  h_scale = 0.9
  w_scale = 0.8
  wrap_container = $("#wrap-container")
  screen_container = $("#screen-container")
  smart_button = $("#smart-button")
  smart_image = $("#smart-image")
  helper_td = $("#helper-td")

  win_w = window.innerWidth
  win_h = window.innerHeight


#  console.log "win w = " + win_w + ", win h = " + win_h
# Basic settings
  wrap_container.width(win_w)
  wrap_container.height(win_h)
  wrap_container.css
    position: "absolute"
    top: 0
    left: 0

# Calculations for 12x9 grid
  temp_screen_container_width = wrap_container.width() * w_scale
  temp_screen_container_height = wrap_container.height() * h_scale
  screen_container_offset_left = temp_screen_container_width % 12
  screen_container_offset_top = temp_screen_container_height % 9
  screen_container_width = temp_screen_container_width - screen_container_offset_left
  screen_container_height = temp_screen_container_height - screen_container_offset_top
  screen_container_left = wrap_container.width() * ((1 - w_scale)/2)
  screen_container_top = wrap_container.height() * ((1 - h_scale)/2)

# Positioning and design main grid panel
  screen_container.css
    position: "absolute"
    left: screen_container_left
    top: screen_container_top
    width: screen_container_width
    height: screen_container_height
    "border": "1px solid #202020"
    "border-radius": "3px"
    "box-shadow": "4px 4px 4px #202020"
    "background-color": "rgb(43,47,52)"

# Positioning and design smart-button
  smart_button.css
    position: "absolute"
    top: 0
    right: 0
    width: screen_container_left
    height: screen_container_top
  helper_td.css
    "text-align": "center"
  smart_image.css
    display: "inline-block"
    width: "100%"