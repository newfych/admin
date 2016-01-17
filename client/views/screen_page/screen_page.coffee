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

Template.ScreenPage.rendered = ->
  resizeElements()
  updateNavbar()

currentId = ->
  Router.current().params.screenId

currentScreen = ->
  screen = Screens.findOne({_id: currentId()}, {})
  return screen and screen.screen

updateNavbar = ->
  left_menu = $("#private-left-menu-items")
  left_menu.append(
    '<li id="screen-page-navbar-element"><a href="#" id="edit">
    <span class="item-title">&nbsp;Edit</span>
    </a></li>')
  left_menu.append(
    '<li id="screen-page-navbar-element"><a href="#" id="rename">
    <span class="item-title">&nbsp;Rename</span>
    </a></li>')
  left_menu.append(
    '<li id="screen-page-navbar-element"><a href="#" id="delete">
    <span class="item-title">&nbsp;Delete</span>
    </a></li>')

resizeElements = ->
  wrap_container = $("#wrap-container")
  win_w = $(window).outerWidth(true)
  win_h = $(window).outerHeight(true)
  nav_h = $("#navbar").outerHeight()
#  console.log "win w = " + win_w + ", win h = " + win_h + ", nav h = " + nav_h
  wrap_container.width(win_w)
  wrap_container.height(win_h - nav_h)
  wrap_container.css
    position: "absolute"
    top: nav_h
  screen_container = $("#screen-container")
  screen_container.width('90%')
  screen_container.height('90%')
  screen_container.css
    position: "absolute"
    left: "50%"
    top: "50%"
    "margin-left": -screen_container.outerWidth() / 2
    "margin-top": -screen_container.outerHeight() / 2
    "border": "1px solid #202020"
    "border-radius": "3px"
    "box-shadow": "4px 4px 4px #202020"
    "background-color": "rgb(43,47,52)"