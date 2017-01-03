# An A* algorithm would probably be faster for Part One, but as the maze (graph)
# is fairly small, for my first working solution, I just used Dijkstra's
# algorithm. As it turned out, Dijkstra was perfect for Part Two anyway,
# so I didn't bother refactoring my tentative Part One solution.

FAVORITE_NUMBER = 1358

class Vertex
  constructor: (@x, @y)->
    @isWall = @determineIfWall(@x, @y)
    @distance = @distanceFromSource(@x, @y)

  determineIfWall: (x, y)->
    sum = x*x + 3*x + 2*x*y + y + y*y + FAVORITE_NUMBER
    onBits = 0
    onBits++ for digit in sum.toString(2).split("") when digit is '1'
    onBits % 2 is 1

  distanceFromSource: (x, y)->
    if x is 1 and y is 1
      0
    else
      Infinity

  findNeighbors: (graph)->
    neighbors = []
    for v in graph
      if (v.x == @x and (v.y == @y+1 or v.y == @y-1)) or (v.y == @y and (v.x == @x+1 or v.x == @x-1))
        neighbors.push(v) unless v.isWall
    neighbors

vertices = []

for y in [0..50]
  for x in [0..50]
    vertices.push(new Vertex(x, y))

dijkstra = (graph)->
  queue = graph[..] # copies original array

  while queue.length > 0
    min = Infinity
    minIndex = undefined

    for v, idx in queue
      if v.distance < min
        min = v.distance
        minIndex = idx

    selectedVertex = queue.splice(minIndex, 1)[0]

    for neighbor in selectedVertex.findNeighbors(graph)
      proposedDistance = selectedVertex.distance + 1
      if proposedDistance < neighbor.distance
        neighbor.distance = proposedDistance

dijkstra(vertices)

# Part One
console.log(v.distance) for v in vertices when v.x == 31 and v.y == 39

# Part Two
validLocations = (v for v in vertices when v.distance <= 50)
console.log(validLocations.length)
