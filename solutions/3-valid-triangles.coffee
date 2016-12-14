file = "../input/input3.txt"
fs = require('fs')
readline = require('readline').createInterface
  terminal: false
  input: fs.createReadStream(file)

checkTriangle = (a, b, c)->
  a + b > c && a + c > b && b + c > a

# Part One
countGoodTriangles = ()->
  count = 0
  readline.on 'line', (line)->
    matchData = line.match(/\s+(\d+)\s+(\d+)\s+(\d+)/)
    a = Number(matchData[1])
    b = Number(matchData[2])
    c = Number(matchData[3])
    count++ if checkTriangle(a, b, c)
    console.log(count)

countGoodTriangles()

# Part Two
countGoodTrianglesVertically = ()->
  count = 0
  arr   = []
  readline.on 'line', (line)->
    matchData = line.match(/\s+(\d+)\s+(\d+)\s+(\d+)/)
    arr.push(Number(matchData[1]))
    arr.push(Number(matchData[2]))
    arr.push(Number(matchData[3]))
    if arr.length is 9
      count++ if checkTriangle(arr[0], arr[3], arr[6])
      count++ if checkTriangle(arr[1], arr[4], arr[7])
      count++ if checkTriangle(arr[2], arr[5], arr[8])
      arr = []
    console.log(count)

countGoodTrianglesVertically()