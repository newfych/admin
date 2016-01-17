Template.AddScreen.rendered = ->
  resizeElements()

resizeElements = ->
  add_screen_container = $("#add-screen-container")
  win_w = $(window).outerWidth(true)
  win_h = $(window).outerHeight(true)
  nav_h = $("#navbar").outerHeight()
  screens_tab_container_h = win_h - nav_h
  add_screen_container_w = Math.floor(win_w/3)
  add_screen_container_h = Math.floor(screens_tab_container_h/2)
  add_screen_container.css
    width: add_screen_container_w
    height: add_screen_container_h
    "border": "2px solid #228822"
    float: "left"