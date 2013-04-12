require 'coffee-script'
should = require 'should'
ytxLib = require '../lib.coffee'
describe 'ytx-lib',->
  describe 'delayCost',->
    it 'should return 0 if day is 0',->
      ytxLib.delayCost(5000, 0).should.eql 0

    it 'should return 15 if day is 1 and value is 5000',->
      ytxLib.delayCost(5000, 1).should.eql 15

    it 'should return 40 if day is 1 and value is 5000 and baseCount is 40',->
      ytxLib.delayCost(5000, 1, {baseCount: 40}).should.eql 40

    it 'should return 30 if day is 1 and value is 5000 and delayFeeRate is 4',->
      ytxLib.delayCost(5000, 1, {delayFeeRate: 4}).should.eql 30

  describe 'tradeCost', ->
    it 'should return 60 if value is 5000',->
      ytxLib.tradeCost(5000).should.eql 60
    it 'should return 22.5 if value is 5000',->
      ytxLib.tradeCost(5000, {tradeFeeRate: 3}).should.eql(22.5)

  describe 'inOut', ->
    it 'should return 0 if in is 5000 and out is 5010',->
      ytxLib.inOut(5000, 5010).should.eql 0

    it 'should return -300 if in is 5000 and out is 4090',->
      ytxLib.inOut(5000, 4990).should.eql -300

    it 'should return 1200 if in is 5000 and out is 5090',->
      ytxLib.inOut(5000, 5090).should.eql 1200

    it 'should return 6000 if in is 5000 and out is 5090',->
      ytxLib.inOut(5000, 5090, 'up', 5).should.eql 6000

    it 'should return -1500 if in is 5000 and out is 5090',->
      ytxLib.inOut(5000, 5010, 'down', 5).should.eql -1500
  describe 'gainFlatValue', ->
    it 'should return between 5000+10 and (5000+10)*1.002 if value is 5000',->
      gainFlatValue = ytxLib.gainFlatValue(5000)
      gainFlatValue.should.be.above(5000+10)
      gainFlatValue.should.be.below((5000+10)*1.002)

    it 'should return between 5000-10 and (5000-10)*0.998 if value is 5000 and direction is down',->
      gainFlatValue = ytxLib.gainFlatValue(5000, 'down')
      gainFlatValue.should.be.below(5000-10)
      gainFlatValue.should.be.above((5000-10)*0.998)

    it 'should return between 5000-10 and (5000-10)*0.999 if value is 5000 and direction is down',->
      gainFlatValue = ytxLib.gainFlatValue(5000, 'down', 0, {tradeFeeRate:3})
      gainFlatValue.should.be.below(5000-10)
      gainFlatValue.should.be.above((5000-10)*0.999)

  describe 'fundCost', ->
    it 'should above 6000 if value 5000',->
      fundCost = ytxLib.fundCost(5000)
      fundCost.should.be.eql(5000 * 1.2)

    it 'should above 5000 * 1.2 + 5000*15*10*0.0002 if value 5000 day 12',->
      fundCost = ytxLib.fundCost(5000, {day:10})
      fundCost.should.be.eql(5000 * 1.2 + 5000*15*10*0.0002)
