Accounts.onLogin (user) ->
#  id = user.user._id
#  if not Screens.findOne({user: id}, {})
#    console.log 'before insert if empty ' + id
#    Screens.insert
#      user: id
#      screen: "main"
#    console.log 'inserted in screens user - ' + id

  if Meteor.isClient
    Meteor.subscribe("Screens")