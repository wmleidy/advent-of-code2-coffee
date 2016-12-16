file = "../input/input6.txt"
fs = require('fs')

decodeMessage = ()->
  charFrequencies = []
  for line in fs.readFileSync(file, 'utf8').split("\n")
    for char, i in line.split("")
      if !charFrequencies[i]?
        charFrequencies[i] = {}
        charFrequencies[i][char] = 1
      else if !charFrequencies[i][char]?
        charFrequencies[i][char] = 1
      else
        charFrequencies[i][char]++
  partOne = (
    for hsh in charFrequencies
      topLetter = ""
      topCount  = 0
      for letter, count of hsh
        if count > topCount
          topCount = count
          topLetter = letter
      topLetter
  ).join("")
  partTwo = (
    for hsh in charFrequencies
      minCount = null
      for letter, count of hsh
        if !minCount? || count < minCount
          minCount = count
          minLetter = letter
      minLetter
  ).join("")
  [partOne, partTwo]

console.log(decodeMessage())