sinon = require('sinon')
Game = require('../../app/models/game')

describe 'Game', ->

  it 'should have a @field property after initialization', ->
    game = new Game()
    game.field.should.be.ok

  it 'should increase the moves when a player picked a color', ->
    game = new Game()
    player = 0
    game.get('moves')[player].should.equal(0)
    game.colorPicked 0, player
    game.get('moves')[player].should.equal(1)

  it 'should update the field when a player picked a color', ->
    game = new Game()
    spy = sinon.spy()
    game.updateField = spy
    player = 0
    color = 0
    game.colorPicked color, player
    spy.called.should.be.true

  it 'should trigger the `over` event when a user wins', ->
    game = new Game()
    spy = sinon.spy()
    game.on 'over', spy
    game.field.getPossessionPercentage = -> 100
    game.colorPicked 0, 0
    spy.called.should.be.true

    spy = sinon.spy()
    game.on 'over', spy
    game.field.getPossessionPercentage = -> 99
    game.colorPicked 0, 0
    spy.called.should.be.false

  describe 'checkIfOver', ->
    it 'should be over when >= 50 percent for one player in multiplayer game', ->
      game = new Game(mode: 'multi')
      game.field.getPossessionPercentage = -> 50
      game.checkIfOver().should.be.true
      game.field.getPossessionPercentage = -> 49
      game.checkIfOver().should.be.false
      game.field.getPossessionPercentage = -> 51
      game.checkIfOver().should.be.true

    it 'should be over when == 100 percent in a single player game', ->
      game = new Game()
      game.field.getPossessionPercentage = -> 50
      game.checkIfOver().should.be.false
      game.field.getPossessionPercentage = -> 100
      game.checkIfOver().should.be.true
