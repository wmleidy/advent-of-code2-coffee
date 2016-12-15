file = "../input/input4.txt"
fs = require('fs')
readline = require('readline').createInterface
  terminal: false
  input: fs.createReadStream(file)

frequencyFinder = (chars)->
  counts = []
  for char in chars
    keycode = char.charCodeAt(0)
    # keeping the keycode/tally object at its index in an array simultaneously
    # solves two potential problems of more "obvious approaches":
    # 1) no easy way to sort an object literal in JavaScript
    # 2) no need to search through array to find correct object to increment
    if counts[keycode]
      counts[keycode].value++
    else
      counts[keycode] = { code: keycode, value: 1 }
  frequencies = (hsh for hsh in counts when hsh?) # CoffeeScript's select/filter
  sortedFrequencies = frequencies.sort (a, b)->
    if b.value != a.value
      b.value - a.value # first try sorting descending by value
    else
      a.code - b.code # if values are equal, sort ascending by char code
  (String.fromCharCode(hsh.code) for hsh in sortedFrequencies[0..4]).join("") # Coffee's map/collect

validator = (sortedFrequencies, checksum)->
  sortedFrequencies == checksum

decrypt = (phrase, num)->
  adjustment = num % 26
  (
    for char in phrase.split("")
      if char is " "
        char
      else
        newCharCode = char.charCodeAt(0) + adjustment
        newCharCode -= 26 if newCharCode > 122
        String.fromCharCode(newCharCode)
  ).join("")

runDecryption = ()->
  sum = 0
  readline.on 'line', (line)->
    matchData = line.match(/(.+)-(\d+)\[([a-z]{5})\]/)
    letters  = matchData[1].split("-").join("").split("")
    sectorID = Number(matchData[2])
    checksum = matchData[3]
    if validator(frequencyFinder(letters), checksum)
      sum += sectorID
      phrase = matchData[1].split("-").join(" ")
      console.log("#{sectorID}: #{decrypt(phrase, sectorID)}") # For Part Two
    console.log(sum) # For Part One

runDecryption()