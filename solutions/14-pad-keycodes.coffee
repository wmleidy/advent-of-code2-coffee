salt = 'qzyelonm'

# Note: Using https://github.com/emn178/js-md5 for md5 functionality
md5 = require('js-md5')

class Key
  constructor: (@index, @char)->
    @quint = @char + @char + @char + @char + @char

generateKeys = (options = {})->
  integer = 0
  potentialKeys = []
  actualKeys = []

  # generating 80 actual keys to ensure that we can find the 64th one,
  # this is necessary because the matches don't come out in order of
  # index, but rather the order of the index with the five-of-a-kind;
  # this allows for keeping a small array of 1000 hashes and saves having
  # to loop 1000 times for each index (in a naive implementation)
  until actualKeys.length >= 80
    testStr = salt + integer
    if options.useStretched
      hex = testStr
      for i in [0...2017]
        hex = md5(hex)
    else
      hex = md5(testStr)

    # maintain potentialKeys array
    if potentialKeys[0]?.index + 1000 < integer
      potentialKeys.shift()

    # search for confirmation of key
    for key in potentialKeys
      if hex.indexOf(key.quint) > -1 and actualKeys.indexOf(key) is -1
        actualKeys.push(key)

    # populate potentialKeys with first triplet
    if matchData = hex.match(/(.)\1\1/)
      potentialKeys.push(new Key(integer, matchData[1]))

    integer++

  actualKeys.sort (a, b)->
    a.index - b.index

console.log(generateKeys()[63].index)
console.log(generateKeys(useStretched: true)[63].index)
