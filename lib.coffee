_ = require('underscore')


middleware = 
  options:
    rateBase: 0.0001
    delayFeeRate: 2
    tradeFeeRate: 8
    baseCount: 15
    diffValue: 10
    fundRate: 0.08

middleware.delayCost = (value, day = 0, options)->
  return 0 if day is 0 

  options = _.extend({},middleware.options,options)
  value * options.baseCount * options.delayFeeRate * options.rateBase  * day

middleware.tradeCost = (value, options)->
  options = _.extend({}, middleware.options, options)
  value * options.baseCount * options.tradeFeeRate * options.rateBase

middleware.inOut = (inValue, outValue, direction = "up", count = 1, options)->
  options = _.extend({}, middleware.options, options)
  perGain = 0
  if direction is 'up'
    perGain = (outValue - inValue - options.diffValue)
  else
    perGain = (inValue - outValue - options.diffValue)

  perGain * options.baseCount * count

middleware.gainFlatValue = (value, direction = "up" ,day=0, options)->
  options = _.extend({}, middleware.options, options)
  upRate = 1+options.rateBase*options.tradeFeeRate
  downRate = 1-options.rateBase*options.tradeFeeRate

  delayFeeRateByDay = options.delayFeeRate * options.rateBase * day

  if direction is 'up'
    (value*(upRate+delayFeeRateByDay)+options.diffValue)/downRate
  else
    (value*(downRate-delayFeeRateByDay)-options.diffValue)/upRate

middleware.fundCost = (value, options)->
  options = _.extend({},middleware.options,options)
  day = options.day ? 0
  value*options.baseCount*(options.fundRate+options.rateBase*options.delayFeeRate*day)

module.exports = middleware
