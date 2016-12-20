file = "../input/input9.txt"
fs = require('fs')

unzipOne = (str)->
  characterCount = 0
  while matchData = str.match(/\((\d+)x(\d+)\)/)
    characterCount += (Number(matchData[1]) * Number(matchData[2]) + matchData.index)
    endingIndex = matchData.index + matchData[0].length + Number(matchData[1])
    str = str[endingIndex..-1]
  characterCount += str.length
  characterCount

console.log(unzipOne(fs.readFileSync(file, 'utf8')))

String.prototype.replaceAt = (index, char)->
  this.substr(0, index) + char + this.substr(index + char.length)

# Note:
# Theory for Part Two is that only "real" characters--those not in parentheses--are counted.
# The trick is to find out how many times each "real" character should be counted toward total.
# This number is the product of all multiplier values in the marker that affect the character.
#
# My solution goes through the string, finds markers, and "processes" them one by one, that is,
# tracks their multipliers' cumulative effect on any "real" characters within their range.
unzipTwo = (str)->
  # character multiplier array setup
  multiplierArray = []
  multiplierArray.push(1) for i in [1..str.length]

  while matchData = str.match(/\((\d+)x(\d+)\)/)
    # isolate indices and string segment we're interested in counting
    startIndex = matchData.index
    endIndex   = matchData.index + matchData[0].length
    segment = str[endIndex...(endIndex + Number(matchData[1]))]

    # modify multiplier array, but only for "real" characters
    countFlag = true
    j = 0
    while j < segment.length
      countFlag = false if segment[j] is "(" # turn multiplying off
      multiplierArray[endIndex + j] *= Number(matchData[2]) if countFlag
      countFlag = true if segment[j] is ")"  # turn multiplying on
      j++

    # clear out marker we just processed so it doesn't match again and doesn't count toward sum
    for i in [startIndex...endIndex]
      str = str.replaceAt(i, "*")
      multiplierArray[i] = 0

  # with all frequencies of each character determined by the multiplier present in its
  # corresponding position in the multiplier array, all that's left to do is to sum up
  sum = 0
  sum += value for value in multiplierArray
  sum

console.log(unzipTwo(fs.readFileSync(file, 'utf8')))
