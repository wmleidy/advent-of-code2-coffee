INPUT = "gdjjyniy"

# Note: Using https://github.com/emn178/js-md5 for md5 functionality
md5 = require('js-md5')

class GameState
  constructor: (@moveHistory, @x, @y)->

  findLegalMoves: ()->
    legalMoves = []
    hash = md5(INPUT + @moveHistory)
    legalMoves.push("U") if @y != 0 and hash[0].match(/[b-f]/)
    legalMoves.push("D") if @y != 3 and hash[1].match(/[b-f]/)
    legalMoves.push("L") if @x != 0 and hash[2].match(/[b-f]/)
    legalMoves.push("R") if @x != 3 and hash[3].match(/[b-f]/)
    legalMoves

  legalNextStates: ()->
    (
      for char in @findLegalMoves()
        switch char
          when 'U' then (new GameState(@moveHistory + 'U', @x, @y - 1))
          when 'D' then (new GameState(@moveHistory + 'D', @x, @y + 1))
          when 'L' then (new GameState(@moveHistory + 'L', @x - 1, @y))
          when 'R' then (new GameState(@moveHistory + 'R', @x + 1, @y))
    )

  isWinningState: ()->
    @x is 3 and @y is 3

# Another breadth-first search with game states for Part One
findShortestPath = (initialState)->
  queue = [initialState]

  while queue.length > 0
    examinedState = queue.shift()
    return examinedState.moveHistory if examinedState.isWinningState()
    for possibleState in examinedState.legalNextStates()
      queue.push(possibleState)

# Since we're finding all results for Part Two, any complete search will do
# included this modified form of BFS
findLongestPath = (initialState)->
  queue = [initialState]
  winningPaths = []

  while queue.length > 0
    examinedState = queue.shift()
    if examinedState.isWinningState()
      winningPaths.push(examinedState.moveHistory.length)
    else
      for possibleState in examinedState.legalNextStates()
        queue.push(possibleState)

  Math.max.apply(Math, winningPaths)

startingState = new GameState("", 0, 0)
console.log(findShortestPath(startingState))
console.log(findLongestPath(startingState))