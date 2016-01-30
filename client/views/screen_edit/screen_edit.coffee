Template.ScreenEdit.helpers
  currentScreenId: ->
    currentScreenId()
  currentScreen: ->
    currentScreenName()

# Observing collection
Controls.find().observeChanges
  added: ->
    console.log "controls added"
    updateAll()

  changed: ->
    console.log "controls changed"
    updateAll()

  removed: ->
    updateAll()
    console.log "controls removed"

# Events
Template.ScreenEdit.events
  "click #add-control": (e, t) ->
    e.preventDefault()
    addControl()

  "click #remove-control": (e, t) ->
    e.preventDefault()
    removeControl()
    console.log 'remove clicked'

  "change #control-select": (e) ->
    currentTarget = e.currentTarget;
    newValue = currentTarget.options[currentTarget.selectedIndex].value
    console.log 'Select changed to : ' + newValue


Template.ScreenEdit.rendered = ->
  updateNavbar()
  resizeElements()
  updateAll()

addControl = ->
  Controls.insert
    user: Meteor.userId()
    screen: currentScreenId()
    control: "control"
    type: "none"
    x: 0
    y: 0
    w: 1
    h: 1
    color: "orange"

removeControl = ->
  control_id = $( "#control-select option:selected" ).text()
  Controls.remove({_id: control_id})

updateAll = ->
  grid_container = $("#grid-container")
  control_select = $("#control-select")

# Empty select and grid before fill them
  control_select.empty()
  grid_container.empty()

# Check for controls entries
  controls_count = currentControls().count()

# Hide unnecessary elements if controls count is null
  if not controls_count
    hidePanelElements()

# Filling grid and select
  if controls_count
    showPanelElements()
    currentControls().forEach (control) ->
      control_select.append("<option>" + control._id + "</option>")
      control_select.children().last().attr("selected", "selected")
      console.log 'before draw control'
      drawControl(control)

hidePanelElements = ->
  $("#control-select").hide()
  $("#remove-control").hide()

showPanelElements = ->
  $("#control-select").show()
  $("#remove-control").show()

drawControl = (control)->
  id = control._id
  x = control.x
  y = control.y
  w = control.w
  h = control.h
  c = control.control
#  console.log 'x = ' + x + ', y = '+y+', w = '+w+', h = '+h+', control = '+ c
  grid_container = $("#grid-container")
  grid_container.append('<div id="' + id + '" class="control-div"></div>')
  ctrl = $("#" + id)
  ctrl.draggable containment: "parent"
  ctrl.resizable containment: "parent"
  ctrl.css
    position: "absolute"
    left: y * @cell_w
    top: x * @cell_h
    width: w * @cell_w
    height: h * @cell_h
    background: "orange"


#  Setting up drag & resize

#  Drag & Resize  Events
  ctrl.draggable
    grid: [ @cell_w, @cell_h ]
    stop: (event, ui) ->
      x = ui.position.top / cell_h
      y = ui.position.left / cell_w
      console.log 'dr left : ' + x
      console.log 'dr top : ' + y
      Controls.update(_id: id, {$set: {x: x, y: y}})

  ctrl.resizable
    grid: [ @cell_w, @cell_h ]
    stop: (event, ui) ->
      w = ui.size.width / cell_w
      h = ui.size.height / cell_h
      console.log '/ w size' + w
      console.log '/ h size' + h
      Controls.update(_id: id, {$set: {w: w, h: h}})

currentControls = ->
  Controls.find({screen: currentScreenId()})

currentScreenId = ->
  Router.current().params.screenId

currentScreenName = ->
  screen = Screens.findOne({_id: currentScreenId()})
  return screen and screen.screen

updateNavbar = ->
  $(".navbar-brand").text(currentScreenName())

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
#  panel_container_left = (wrap_panel_container_w - panel_container_w)/2
  panel_container.css
    position: "absolute"
    width: panel_container_w
    top: grid_container_top
#    left: panel_container_left

