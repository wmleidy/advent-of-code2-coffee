file = "../input/input20.txt"
fs = require('fs')

generateRanges = ()->
  ranges = []
  for line in fs.readFileSync(file, 'utf8').split("\n")
    ranges.push(line.split("-").map (num)-> Number(num))
  ranges.sort (a, b)->
    a[0] - b[0]

findFirstGap = (ranges)->
  return 0 if ranges[0][0] != 0

  for pair, index in ranges when index != ranges.length - 1
    if pair[1] + 1 < ranges[index + 1][0]
      return pair[1] + 1

  highestRangeEnd = Math.max.apply(Math, ranges.map (pair)-> pair[1])
  if highestRangeEnd is 4294967295 then null else highestRangeEnd

# O(n^2) solution on order of 10^6 operations, but still much quicker
# testing every number, and while there's room for further optimization,
# both parts together run in 25ms, so that's quick enough for me
countAllGaps = (ranges)->
  count = 0
  count += ranges[0][0] # initial gap
  for pair, index in ranges when index != ranges.length - 1
    endCurrentRange = pair[1] + 1

    # find start point of next valid range
    closestNextRangeStart = 4294967295
    for secondPair in ranges
      if secondPair[0] < closestNextRangeStart and secondPair[1] > endCurrentRange
        closestNextRangeStart = secondPair[0]

    if endCurrentRange < closestNextRangeStart
      count += (closestNextRangeStart - endCurrentRange) # add interior gaps to count

  count += (4294967295 - Math.max.apply(Math, ranges.map (pair)-> pair[1])) # trailing gap
  count

console.log(findFirstGap(generateRanges()))
console.log(countAllGaps(generateRanges()))