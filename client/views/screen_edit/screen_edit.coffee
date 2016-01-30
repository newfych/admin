Template.ScreenEdit.helpers
  currentScreenId: ->
    currentScreenId()
  currentScreen: ->
    currentScreenName()

# Observing collection
Controls.find().observeChanges
  added: ->
    updateAll()

  changed: ->
    updateAll()

  removed: ->
    updateAll()

# Events
Template.ScreenEdit.events
  "click #add-control": (e, t) ->
    e.preventDefault()
    addControl()

  "click #remove-control": (e, t) ->
    e.preventDefault()
    removeControl()

  "click #rename-control": (e, t) ->
    e.preventDefault()
    console.log 'rename'
    e.preventDefault()
    bootbox.prompt
      title: "Enter Control name"
      inputType: "text"
      buttons:
        confirm:
          label: "Submit"
      callback: (value) ->
        value and renameControl(currentControlId(), value)

  "click #change-type": (e, t) ->
    e.preventDefault()
    bootbox.dialog
      message: "Select type"
#      title: "Custom title"
      buttons:
        none:
          label: "None"
          className: "btn-default form-control"
          callback: ->
            console.log 'None'
            changeControlType(currentControlId(), "none")

        button:
          label: "Button"
          className: "btn-default form-control"
          callback: ->
            changeControlType(currentControlId(), "button")

        cancel:
          label: "Cancel"
          className: "btn-primary form-control"
          callback: ->
            console.log 'Cancel'

  "change #control-select": (e) ->
    currentTarget = e.currentTarget;
    new_value = currentTarget.options[currentTarget.selectedIndex].value
    console.log 'Select changed to : ' + new_value
    console.log 'id ====== ' + currentControlId()
    t = Controls.findOne({_id: currentControlId()}).type
    console.log 'type is ' + t
    $("#control-type").val(t)




Template.ScreenEdit.rendered = ->
  updateNavbar()
  resizeElements()
  updateAll()

addControl = ->
  Controls.insert
    user: Meteor.userId()
    screen: currentScreenId()
    name: ""
    type: "none"
    x: 0
    y: 0
    w: 1
    h: 1
    color: "orange"

currentControlId = ->
  control_name = $( "#control-select option:selected" ).text()
  control = Controls.findOne({name: control_name})
  if control._id
    return control._id

removeControl = ->
  Controls.remove({_id: currentControlId()})

# UPDATE ALL THINGS
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
    console.log 'Controls count exists'
    showPanelElements()
    clearControlsArrays()
    currentControls().forEach (control) ->
      sortControls(control)
    currentControls().forEach (control) ->
      namingControls(control)
    currentControls().forEach (control) ->
      fillSelect(control)
    currentControls().forEach (control) ->
      drawControl(control)

    setCurrentControl()


#    control_select.children().last().attr("selected", "selected")

setCurrentControl = ->
  console.log 'set curren cntrl'
  control_select = $("#control-select")
  control_type = $("#control-type")
  control_select.children().last().attr("selected", "selected")
  control_type.val(getControlType())

getControlType = ->
  control_name = $( "#control-select option:selected" ).text()
  console.log 'Name == '+ control_name
  control = Controls.findOne(name: control_name)
  if control
    console.log 'control == ' + control.type
    return control.type

# Clear Controls Arrays
clearControlsArrays = ->
  @none = []
  @buttons = []

fillSelect = (control)->
  control_select = $("#control-select")
  control_name = control.name
  control_select.append("<option>" + control_name + "</option>")

namingControls = (control) ->
  control_id = control._id
  control_type = control.type
  if control_type is "none"
    name = "none_" + @none.indexOf(control_id)
    renameControl(control_id, name)
  else if control_type is "button"
    name = "button_" + @buttons.indexOf(control_id)
    renameControl(control_id, name)

# Change control type
changeControlType = (id, type) ->
  Controls.update
    _id: id
  ,
    $set:
      type: type
  updateAll()

# Rename control
renameControl = (id, name) ->
  Controls.update
    _id: id
  ,
    $set:
      name: name

# Sort controls for give them indexes
sortControls = (control) ->
  control_type = control.type
  control_id = control._id
  if control_type is "none"
    @none.push(control_id)
  if control_type is "button"
    @buttons.push(control_id)


hidePanelElements = ->
  $("#control-select").hide()
  $("#remove-control").hide()
  $("#control-type").hide()

showPanelElements = ->
  $("#control-select").show()
  $("#remove-control").show()
  $("#control-type").show()

drawControl = (control)->
  id = control._id
  x = control.x
  y = control.y
  w = control.w
  h = control.h
  name = control.name
#  console.log 'x = ' + x + ', y = '+y+', w = '+w+', h = '+h+', control = '+ c
  grid_container = $("#grid-container")
  grid_container.append('<div id="' + id + '" class="control-div">' + name + '</div>')
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

#  Setting Drag & Resize  Events
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
  panel_container.css
    position: "absolute"
    width: panel_container_w
    top: grid_container_top

