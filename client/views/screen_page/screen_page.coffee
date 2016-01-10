Template.ScreenPage.helpers
  currentId: ->
    Router.current().params.screenId

Template.PrivateLayout.events
  "click #edit": (e, t) ->
    e.preventDefault()
    console.log 'edit clicked : ' + Router.current().params.screenId
    Router.go "screen_edit",
      screenId: Router.current().params.screenId

Template.ScreenPage.rendered = ->
  resizeElements()
  updateNavbar()

updateNavbar = ->
  left_menu = $("#private-left-menu-items")
  left_menu.append(
    '<li id="screen-page-navbar-element"><a href="#" id="edit">
    <span class="item-title">&nbsp;Edit</span>
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