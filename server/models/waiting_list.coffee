waiting_list = []

module.exports =

  # gets an opponent for the player and removes both from the waitng list
  getOpponentFor: (player, cb) ->
    # if there are no waiting players at the moment, return null
    if waiting_list.length is 0
      cb null, null
    else
      # iterate the waiting list to find a player
      for waitingPlayer in waiting_list
        if waitingPlayer isnt player
          opponent = waitingPlayer
          break

      # return opponent and remove both from waiting list
      if opponent?
        @remove [opponent, player], (err) ->
          cb null, opponent
      else
        # if no opponent was found, return null
        cb null, null

  add: (player, cb) ->
    index = waiting_list.indexOf player
    if index is -1
      waiting_list.push player
    cb null

  remove: (players, cb) ->
    # iterate over the players
    for player in players
      index = waiting_list.indexOf player
      if index > -1
        waiting_list.splice index, 1

    cb null

  clear: ->
    waiting_list = []

  length: (cb) ->
    cb waiting_list.length
