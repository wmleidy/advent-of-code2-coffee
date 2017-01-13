# Note: the math behind this pattern is Rule 90 (https://en.wikipedia.org/wiki/Rule_90)

input = ".^.^..^......^^^^^...^^^...^...^....^^.^...^.^^^^....^...^^.^^^...^^^^.^^.^.^^..^.^^^..^^^^^^.^^^..^"

convertInput = (string)->
  (
    for char in string.split("")
      if char == "." then false else true
  )

determineIfTrap = (left, center, right)->
  if left && center && !right
    true
  else if !left && center && right
    true
  else if left && !center && !right
    true
  else if !left && !center && right
    true
  else
    false


generateRows = (input, numberOfRows)->
  rows = [input]
  for y in [0...numberOfRows-1]
    rows.push([])
    for x in [0...input.length]
      isTrap = if x is 0
        determineIfTrap(false, rows[y][x], rows[y][x+1])
      else if x is input.length - 1
        determineIfTrap(rows[y][x-1], rows[y][x], false)
      else
        determineIfTrap(rows[y][x-1], rows[y][x], rows[y][x+1])
      rows[y+1][x] = isTrap
  rows

countSafeTiles = (matrix)->
  count = 0
  for row in matrix
    for cellIsTrap in row
      count++ unless cellIsTrap
  count

console.log(countSafeTiles(generateRows(convertInput(input), 40)))
console.log(countSafeTiles(generateRows(convertInput(input), 400000)))
