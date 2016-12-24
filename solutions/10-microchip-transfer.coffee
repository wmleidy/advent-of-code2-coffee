# Procedural, messy, and in need of a refactor, but works!

file = "../input/input10.txt"
fs = require('fs')

setupBotMap = ()->
  arr = []
  arr.push([]) for i in [1..255]
  arr

botMap = setupBotMap()
outputMap = []

gatherCommands = ()->
  arr = []
  for line in fs.readFileSync(file, 'utf8').split("\n")
    arr.push(line)
  arr

commands = gatherCommands()

indexOfMatchingBot = ()->
  for chips, botNumber in botMap
    return botNumber if chips[0] == 17 and chips[1] == 61
  -1

assignChip = (botNumber, chipNumber)->
  if botMap[botNumber].length is 0 || chipNumber > botMap[botNumber][0]
    botMap[botNumber].push(chipNumber)
  else
    botMap[botNumber].unshift(chipNumber)

sendToOutput = (outputNumber, chipNumber)->
  outputMap[outputNumber] = chipNumber

parseInstructions = ()->
  # until indexOfMatchingBot() > -1 # Part One
  until commands.length is 0 # Part Two
    processedLine = null
    until processedLine?
      for cmd, lineNumber in commands
        if matchData = cmd.match(/value (\d+) goes to bot (\d+)/)
          chip = Number(matchData[1])
          bot  = Number(matchData[2])
          assignChip(bot, chip)
          processedLine = lineNumber
          console.log("value on line #{lineNumber} processed")
          break
        else
          matchData = cmd.match(/bot (\d+) gives low to (\w+) (\d+) and high to (\w+) (\d+)/)
          passingBot = Number(matchData[1])
          if botMap[passingBot].length is 2
            # pass along low chip
            lowTarget = Number(matchData[3])
            if matchData[2] is 'bot'
              assignChip(lowTarget, botMap[passingBot][0])
            else
              sendToOutput(lowTarget, botMap[passingBot][0])

            # pass along high chip
            highTarget = Number(matchData[5])
            if matchData[4] is 'bot'
              assignChip(highTarget, botMap[passingBot][1])
            else
              sendToOutput(highTarget, botMap[passingBot][1])

            # clean bot and marked as processed
            botMap[passingBot] = []
            processedLine = lineNumber
            console.log("transfer from bot #{passingBot} processed")
            break
    # remove command from list and iterate again
    commands.splice(processedLine, 1)
  # indexOfMatchingBot() # Part One
  outputMap[0] * outputMap[1] * outputMap[2] # Part Two

console.log("The answer is #{parseInstructions()}.")