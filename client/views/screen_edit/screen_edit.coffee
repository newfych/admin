Template.ScreenEdit.helpers
  currentId: ->
    currentId()
  currentScreen: ->
    currentScreen()

Template.ScreenEdit.events
  "click #add-control": (e, t) ->
    e.preventDefault()
    addControl()

  "click #remove-control": (e, t) ->
    e.preventDefault()
    console.log 'remove clicked clicked'

Template.ScreenEdit.rendered = ->
  updateNavbar()
  resizeElements()

addControl = ->
  id = Screens.update({_id: currentId()},{$set: {controls: {control: "new_control"}}})._id
  grid_container = $("#grid-container")
  grid_container.append('<div id="' + id + '"></div>')

currentId = ->
  Router.current().params.screenId

currentScreen = ->
  screen = Screens.findOne({_id: currentId()}, {})
  return screen and screen.screen

updateNavbar = ->
  $(".navbar-brand").text(currentScreen())

resizeElements = ->
  grid_width = 0.8
  grid_inner = 0.9
  panel_inner = 0.9
  edit_container = $("#edit-container")
  wrap_grid_container = $("#wrap-grid-container")
  wrap_panel_container = $("#wrap-panel-container")
  grid_container = $("#grid-container")
  panel_container = $("#panel-container")

  win_w = $(window).outerWidth(true)
  win_h = $(window).outerHeight(true)
  nav_h = $("#navbar").outerHeight()
#  Computations
  edit_container_h = win_h - nav_h
  wrap_grid_container_w = win_w * grid_width
  wrap_panel_container_w = win_w * (1 - grid_width)

  #  console.log "win w = " + win_w + ", win h = " + win_h + ", nav h = " + nav_h
#  Edit container
  edit_container.css
    position: "absolute"
    top: nav_h
    width: win_w
    height: edit_container_h

#  Wrap grid container
  wrap_grid_container.css
    position: "absolute"
    top: 0
    left: 0
    width: wrap_grid_container_w
    height: edit_container_h

#  Wrap panel container
  wrap_panel_container.css
    position: "absolute"
    top: 0
    right: 0
    width: wrap_panel_container_w
    height: edit_container_h

#  Grid container
  cell_color = "SlateGrey"
  cell_line_w = 2
  temp_grid_container_w = wrap_grid_container_w * grid_inner
  temp_grid_container_h = edit_container_h * grid_inner
  grid_width_offset = temp_grid_container_w % 12
  grid_height_offset = temp_grid_container_h % 9
  @grid_container_w = temp_grid_container_w - grid_width_offset
  @grid_container_h = temp_grid_container_h - grid_height_offset
  grid_container_left = (wrap_grid_container_w - grid_container_w)/2
  grid_container_top = (edit_container_h - grid_container_h)/2
  grid_container.css
    position: "absolute"
    width: @grid_container_w + cell_line_w*2
    height: @grid_container_h + cell_line_w*2
    top: grid_container_top
    left: grid_container_left
    "border": "1px solid #202020"
    "border-radius": "3px"
    "box-shadow": "4px 4px 4px #202020"
#    "background-color": "rgb(43,47,52)"

#Grid to grid :)
  @cell_w = @grid_container_w / 12
  @cell_h = @grid_container_h / 9
  background_size = @cell_w + "px " + @cell_h + "px"
  gradient = cell_color+" "+cell_line_w+"px, transparent 1px)"
  background_image1 = "linear-gradient(to right, " + gradient
  background_image2 = "linear-gradient(to bottom, " + gradient
  background_image = background_image1 + ", " + background_image2
  grid_container.css
    "background-size": background_size
    "background-image": background_image

#  Panel container
  panel_container_w = wrap_panel_container_w * panel_inner
  panel_container_left = (wrap_panel_container_w - panel_container_w)/2
  panel_container.css
    position: "absolute"
    width: panel_container_w
    top: grid_container_top
#    left: panel_container_left

