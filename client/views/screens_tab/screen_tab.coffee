Template.ScreenTab.rendered = ->
  resizeElements()

resizeElements = ->
  screen_tab_container = $(".screen-tab")
  win_w = $(window).outerWidth(true)
  win_h = $(window).outerHeight(true)
  nav_h = $("#navbar").outerHeight()
  screens_tab_container_h = win_h - nav_h
  screen_tab_container_w = Math.floor(win_w/3)
  screen_tab_container_h = Math.floor(screens_tab_container_h/2)
  screen_tab_container.css
    width: screen_tab_container_w
    height: screen_tab_container_h
    "border": "2px solid #228888"
    float: "left"