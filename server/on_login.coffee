Accounts.onLogin (user) ->
  id = user.user._id
  if not Screens.findOne({user: id}, {})
    console.log 'before insert if empty ' + id
    Screens.insert
      user: id
      screen: "main"
    console.log 'inserted in screens user - ' + id

#  console.log "Collections PUBLISHED (before) - " + id
#  Meteor.publish "Screens", ->
#    screens = Screens.find(user: id)
#    console.log screens
#    return screens if screens
#    @ready()

  if Meteor.isClient
    Meteor.subscribe("Screens")