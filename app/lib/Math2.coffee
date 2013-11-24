Math2 =
  random: (from, to) -> Math.random() * (to - from) + from

  map: (val, inputMin, inputMax, outputMin, outputMax) ->
    ((outputMax - outputMin) * ((val - inputMin) / (inputMax - inputMin))) + outputMin

  randomPlusMinus: (chance) ->
    chance = if chance then chance else 0.5
    if Math.random() > chance then -1 else 1

  randomInt: (from, to) -> Math.floor Math.random() * (++to - from) + from

  randomBool: (chance) ->
    chance = if chance then chance else 0.5
    Math.random() < chance


module.exports = Math2