file = "../input/input3.txt"
fs = require('fs')

checkTriangle = (a, b, c)->
  a + b > c && a + c > b && b + c > a

# Part One
countGoodTriangles = ()->
  count = 0
  for line in fs.readFileSync(file, 'utf8').split("\n")
    matchData = line.match(/\s+(\d+)\s+(\d+)\s+(\d+)/)
    a = Number(matchData[1])
    b = Number(matchData[2])
    c = Number(matchData[3])
    count++ if checkTriangle(a, b, c)
  count

console.log(countGoodTriangles())

# Part Two
countGoodTrianglesVertically = ()->
  count = 0
  arr   = []
  for line in fs.readFileSync(file, 'utf8').split("\n")
    matchData = line.match(/\s+(\d+)\s+(\d+)\s+(\d+)/)
    arr.push(Number(matchData[1]))
    arr.push(Number(matchData[2]))
    arr.push(Number(matchData[3]))
    if arr.length is 9
      count++ if checkTriangle(arr[0], arr[3], arr[6])
      count++ if checkTriangle(arr[1], arr[4], arr[7])
      count++ if checkTriangle(arr[2], arr[5], arr[8])
      arr = []
  count

console.log(countGoodTrianglesVertically())