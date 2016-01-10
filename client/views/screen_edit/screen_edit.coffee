Template.ScreenEdit.helpers
  currentId: ->
    Router.current().params.screenId

Template.ScreenEdit.rendered = ->
  resizeElements()

resizeElements = ->
  grid_w = 0.8
  wrap_grid_container = $("#wrap-grid-container")
  wrap_panel_container = $("#wrap-panel-container")
  win_w = $(window).outerWidth(true)
  win_h = $(window).outerHeight(true)
  nav_h = $("#navbar").outerHeight()
  container_h = win_h - nav_h
  #  console.log "win w = " + win_w + ", win h = " + win_h + ", nav h = " + nav_h
  wrap_grid_container.width(win_w * grid_w)
  wrap_grid_container.height(container_h)
  wrap_grid_container.css
    position: "absolute"
    top: nav_h
    left: 0
  wrap_panel_container.width(win_w * (1 - grid_w))
  wrap_panel_container.height(container_h)
  wrap_panel_container.css
    position: "absolute"
    top: nav_h
    right: 0
  grid_container = $("#grid-container")
  grid_container.width('90%')
  grid_container.height('90%')
  grid_container.css
    position: "relative"
    left: "50%"
    top: "50%"
    "margin-left": -grid_container.outerWidth() / 2
    "margin-top": -grid_container.outerHeight() / 2
    "border": "1px solid #202020"
    "border-radius": "3px"
    "box-shadow": "4px 4px 4px #202020"
    "background-color": "rgb(43,47,52)"
  panel_container = $("#panel-container")