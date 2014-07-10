waitingList = require('../../server/models/waiting_list')

describe 'WaitingList', ->
  player1 = player2 = null

  beforeEach ->
    # clear the list
    waitingList.clear()

    player1 = id: 1
    player2 = id: 2

  it 'should add a player', (done) ->
    waitingList.length (length) ->
      length.should.equal 0
      waitingList.add player1, (err) ->
        waitingList.length (length) ->
          length.should.equal 1
          done()

  it 'should remove a player', (done) ->
    waitingList.add player1, (err) ->
      waitingList.remove [player1], (err) ->
        waitingList.length (length) ->
          length.should.equal 0
          done()

  it 'should return an opponent for a player', (done) ->
    waitingList.add player1, (err) ->
      waitingList.add player2, (err) ->
        waitingList.getOpponentFor player1, (err, opponent) ->
          opponent.should.be.ok
          opponent.should.equal player2
          done()

  it 'should not return an opponent if only one player in list', (done) ->
    waitingList.add player1, (err) ->
      waitingList.getOpponentFor player1, (err, opponent) ->
        (opponent is null).should.be.true
        done()
