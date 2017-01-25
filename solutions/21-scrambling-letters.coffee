file = "../input/input21.txt"
fs = require('fs')
input = "abcdefgh"

gatherCommands = ()->
  arr = []
  for line in fs.readFileSync(file, 'utf8').split("\n")
    arr.push(line)
  arr

swapPositions = (arr, i, j)->
  [arr[i], arr[j]] = [arr[j], arr[i]]

rotateLeft = (arr, steps)->
  for i in [0...steps]
    arr.push(arr.shift())

rotateRight = (arr, steps)->
  for i in [0...steps]
    arr.unshift(arr.pop())

reverseSection = (arr, i, j)->
  reversed = arr[i..j].reverse()
  arr[i..j] = reversed

moveChar = (arr, i, j)->
  removed = arr.splice(i, 1)[0]
  arr.splice(j, 0, removed)

processCommands = (commands, chars)->
  for cmd, idx in commands
    if matchData = cmd.match(/swap position (\d+) with position (\d+)/)
      swapPositions(chars, Number(matchData[1]), Number(matchData[2]))
    else if matchData = cmd.match(/swap letter (.) with letter (.)/)
      pos1 = chars.indexOf(matchData[1])
      pos2 = chars.indexOf(matchData[2])
      swapPositions(chars, pos1, pos2)
    else if matchData = cmd.match(/rotate (left|right) (\d+) step/)
      if matchData[1] is "left"
        rotateLeft(chars, Number(matchData[2]))
      else
        rotateRight(chars, Number(matchData[2]))
    else if matchData = cmd.match(/rotate based on position of letter (.)/)
      steps = chars.indexOf(matchData[1])
      steps++ if steps > 3
      steps++
      rotateRight(chars, steps)
    else if matchData = cmd.match(/reverse positions (\d+) through (\d+)/)
      reverseSection(chars, Number(matchData[1]), Number(matchData[2]))
    else if matchData = cmd.match(/move position (\d+) to position (\d+)/)
      moveChar(chars, Number(matchData[1]), Number(matchData[2]))
  chars.join("")

console.log(processCommands(gatherCommands(), input.split("")))