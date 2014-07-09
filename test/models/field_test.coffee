Field = require('../../app/models/field')

describe 'Field', ->

  it 'should create three representations of the field', ->
    field = new Field()
    field.get('possessions').should.be.ok
    field.get('colors').should.be.ok
    field.get('original').should.be.ok

  it 'should correctly determine if a field is free', ->
    field = new Field()
    field.set('possessions', [[Field.free, 0]])
    field.isFree(0, 0).should.be.true
    field.isFree(1, 0).should.be.false

  it 'should correctly determine a position\'s color', ->
    field = new Field()
    field.set('colors', [[0,1,2]])
    field.isColor(0, 0, 0).should.be.true
    field.isColor(1, 0, 1).should.be.true
    field.isColor(2, 0, 0).should.be.false
