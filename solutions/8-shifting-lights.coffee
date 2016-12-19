file = "../input/input8.txt"
fs = require('fs')

buildRow = ()->
  row = []
  row.push(0) for i in [1..50]
  row

buildGrid = ()->
  grid = []
  grid.push(buildRow()) for i in [1..6]
  grid

lightRect = (x, y, grid)->
  for j in [0...y]
    for i in [0...x]
      grid[j][i] = 1
  grid

rotateRow = (row, offset, grid)->
  rotated = grid[row].splice((offset * -1), offset)
  grid[row] = rotated.concat(grid[row])
  grid

rotateColumn = (column, offset, grid)->
  oldValues = []
  oldValues.push(grid[i][column]) for i in [0...grid.length]
  rotated = oldValues.splice((offset * -1), offset)
  newValues = rotated.concat(oldValues)
  for i in [0...grid.length]
    grid[i][column] = newValues.shift()
  grid

processInstructions = ()->
  grid = buildGrid()
  for line in fs.readFileSync(file, 'utf8').split("\n")
    if matchData = line.match(/rect\s(\d+)x(\d+)/)
      grid = lightRect(matchData[1], matchData[2], grid)
    else if matchData = line.match(/rotate\srow\sy=(\d+)\sby\s(\d+)/)
      grid = rotateRow(matchData[1], matchData[2], grid)
    else if matchData = line.match(/rotate\scolumn\sx=(\d+)\sby\s(\d+)/)
      grid = rotateColumn(matchData[1], matchData[2], grid)
  grid

countLights = (grid)->
  count = 0
  for row in grid
    for cell in row
      count++ if cell == 1
  count

asciiArtify = (grid)->
  str = ""
  for row in grid
    for cell in row
      if cell == 1 then str += "*" else str += " "
    str += "\n"
  str

console.log(countLights(processInstructions()))
console.log(asciiArtify(processInstructions()))
