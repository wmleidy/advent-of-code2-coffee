file = "../input/input22.txt"
fs = require('fs')

class Node
  constructor: (@x, @y, @size, @used, @available)->
    @char = @charRepresentation()
    @swaps = if @char == "_" then 0 else Infinity

  charRepresentation: ()->
    if @used == 0
      "_"
    else if @used > 100
      "#"
    else
      "."

  isViableWith: (otherNode)->
    return false if @used == 0
    return false if @x == otherNode.x and @y == otherNode.y
    @used <= otherNode.available

  adjacentNodes: (grid)->
    adjacent = []
    for n in grid
      if (n.x == @x and (n.y == @y+1 or n.y == @y-1)) or (n.y == @y and (n.x == @x+1 or n.x == @x-1))
        adjacent.push(n) unless n.char is "#"
    adjacent

nodes = []
maxX = 0
maxY = 0
for line in fs.readFileSync(file, 'utf8').split("\n")
  if parsed = line.match(/\/dev\/grid\/node-x(\d+)-y(\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T/)
    parsed = (Number(i) for i in parsed)
    nodes.push(new Node(parsed[1], parsed[2], parsed[3], parsed[4], parsed[5]))
    maxX = parsed[1] if parsed[1] > maxX
    maxY = parsed[2] if parsed[2] > maxY

# Part One
viableCount = 0
for node in nodes
  for otherNode in nodes
    viableCount++ if node.isViableWith(otherNode)
console.log(viableCount)

# Part Two

# grid visualization (exclusively for human use)
grid = ""
for num in [0..maxY]
  charArr = []
  for node in nodes when node.y == num
    charArr[node.x] = node.char
  grid = grid + charArr.join("") + "\n"
console.log(grid)

# Reusing previous code from Day 13 to calculate minimum number of swaps
dijkstra = (graph)->
  queue = graph[..] # copies original array

  while queue.length > 0
    min = Infinity
    minIndex = undefined

    for n, idx in queue
      if n.swaps < min
        min = n.swaps
        minIndex = idx

    selectedNode = queue.splice(minIndex, 1)[0]

    for adj in selectedNode.adjacentNodes(nodes)
      proposedSwaps = selectedNode.swaps + 1
      if proposedSwaps < adj.swaps
        adj.swaps = proposedSwaps

# assign smallest numbers of swaps of cursor to each node
dijkstra(nodes)

# as written this seems pretty opaque, but here's what's going on:
# 1) the cursor (the empty memory cell) starts somewhere in our grid
# 2) the initial goal is to get the cursor to the data node (maxX, 0)
# 3) due to the nature of the memory grid, the number of data swaps
#    required to get the cursor to the data is a maze-crawling problem
# 4) the Dijkstra algorithm above calculates the number of swaps
#    necessary to get the cursor to each and every node on the grid
#    (not as efficient as A*, but it's already been written so...)
# 5) but we're only interested in number of swaps to data node
# 6) once the cursor is at (maxX, 0), it takes a full rotation of 5
#    cursor swaps to advance the data one step closer to the origin
# 7) therefore, the total number of swaps is the number of swaps to
#    get the cursor to the data node, plus 5 times the linear distance
#    between (0,0) and (maxX - 1, 0) (minus one because the data is
#    at (maxX -1, 0) when the cursor is at (maxX, 0))
#
# NOTE: the 5 cursor swap to move the data one space forward assumes
# a clear path without any "blocking" nodes between the data node and
# the origin; luckily, my input provided a clear path, otherwise this
# calculation would have been much more hairy and I would have had to
# think deeper about this problem
shortestPathToData = ()->
  dataNode = node for node in nodes when node.x is maxX and node.y is 0
  swapsForOneRotation = 5
  numberOfCircularSwapsNeeded = maxX - 1
  dataNode.swaps + (numberOfCircularSwapsNeeded * swapsForOneRotation)

console.log(shortestPathToData())