file = "../input/input22.txt"
fs = require('fs')

class Node
  constructor: (@x, @y, @size, @used, @available)->

  isViableWith: (otherNode)->
    return false if @used == 0
    return false if @x == otherNode.x and @y == otherNode.y
    @used <= otherNode.available

nodes = []
for line in fs.readFileSync(file, 'utf8').split("\n")
  if parsed = line.match(/\/dev\/grid\/node-x(\d+)-y(\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T/)
    parsed = (Number(i) for i in parsed)
    nodes.push(new Node(parsed[1], parsed[2], parsed[3], parsed[4], parsed[5]))

# Part One
viableCount = 0
for node in nodes
  for otherNode in nodes
    viableCount++ if node.isViableWith(otherNode)
console.log(viableCount)
