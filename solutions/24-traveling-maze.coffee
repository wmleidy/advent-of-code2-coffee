# I recognized pretty quickly that this a problem that combines maze crawling and
# the classic traveling salesman problem. Rather than crawl through the maze in
# each possible order, I found the shortest distance between each pair of numbered
# locations in the maze, and then ran those numbers through a quickly thrown
# together traveling salesman algorithm to find the shortest path.

# There is a lot of refactoring and optimization that can be done here. Basically,
# the only optimization in place is to not to return to previously visited locations
# when path crawling. The class-based modeling of the maze and its "nodes," the
# inefficient way of finding neighbors, and doing double the work in finding all shortest
# paths (e.g. 0 -> 7 and 7 -> 0 are both found, despite that the fact that these
# distances will always be the same) could all be improved upon.

# It takes roughly 10 seconds to run each part as it's currently written.

file = "../input/input24.txt"
fs = require('fs')
NUMBERS = ["0", "1", "2", "3", "4", "5", "6", "7"]

class Node
  constructor: (@x, @y, @value)->

  toString: ()->
    "x#{@x}y#{@y}"

  isWall: ()->
    @value is "#"

  isTarget: (targetNumber)->
    @value is targetNumber

  findNeighbors: (graph)->
    neighbors = []
    for n in graph.nodes
      if (n.x == @x and (n.y == @y+1 or n.y == @y-1)) or (n.y == @y and (n.x == @x+1 or n.x == @x-1))
        neighbors.push(n) unless n.isWall()
    neighbors

class Graph
  constructor: ()->
    @nodes = @buildMaze()

  buildMaze: ()->
    maze = []
    for line, y in fs.readFileSync(file, 'utf8').split("\n")
      for char, x in line.split("")
        maze.push(new Node(x, y, char))
    maze

  findNumberedNode: (targetNumber)->
    filtered = @nodes.filter (node)-> node.value is targetNumber
    filtered[0]

class GameState
  constructor: (@cursorNode, @moves = 0, @nodesVisited = [])->
    @nodesVisited.push(@cursorNode.toString())

findShortestPath = (startNumber, endNumber)->
  maze = new Graph()
  startingNode = maze.findNumberedNode(startNumber)

  initialState = new GameState(startingNode)

  queue = [initialState]

  while queue.length > 0
    examinedState = queue.shift()
    return examinedState.moves if examinedState.cursorNode.isTarget(endNumber)
    for neighborNode in examinedState.cursorNode.findNeighbors(maze)
      unless examinedState.nodesVisited.indexOf(neighborNode.toString()) > -1
        queue.push(new GameState(neighborNode, examinedState.moves + 1, examinedState.nodesVisited))

findAllShortestPaths = ()->
  paths = []
  for start in NUMBERS
    for end in NUMBERS
      paths.push([start, end, findShortestPath(start, end)])

  paths

allPathDistances = findAllShortestPaths()

# http://stackoverflow.com/questions/9960908/permutations-in-javascript
findPermutations = (input)->
  permutations = []
  usedChars = []

  permute = (input)->
    for i in [0...input.length]
      char = input.splice(i, 1)[0]
      usedChars.push(char)
      permutations.push(usedChars.slice()) if input.length is 0
      permute(input)
      input.splice(i, 0, char)
      usedChars.pop()
    permutations

  permute(input)

destinations = NUMBERS[1..7]
allPossiblePaths = findPermutations(destinations)
allPossiblePaths = allPossiblePaths.map (path)->
  path.unshift("0")
  path.push("0") # For Part Two (comment out for Part One)
  path

findBestTravelPath = (distances, visitOrders)->
  shortestDistance = Infinity
  bestPath = null

  for visitOrder in visitOrders
    cumulativeDistance = 0
    for i in [0...visitOrder.length - 1]
      filtered = distances.filter (distance) ->
        distance[0] is visitOrder[i] and distance[1] is visitOrder[i+1]
      cumulativeDistance += filtered[0][2]
    if cumulativeDistance < shortestDistance
      shortestDistance = cumulativeDistance
      bestPath = visitOrder

  console.log("Shortest path is #{shortestDistance} moves in order #{visitOrder}")

findBestTravelPath(allPathDistances, allPossiblePaths)