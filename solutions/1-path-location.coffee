input = "R3, R1, R4, L4, R3, R1, R1, L3, L5, L5, L3, R1, R4, L2, L1, R3, L3, R2, R1, R1, L5, L2, L1, R2, L4, R1, L2, L4, R2, R2, L2, L4, L3, R1, R4, R3, L1, R1, L5, R4, L2, R185, L2, R4, R49, L3, L4, R5, R1, R1, L1, L1, R2, L1, L4, R4, R5, R4, L3, L5, R1, R71, L1, R1, R186, L5, L2, R5, R4, R1, L5, L2, R3, R2, R5, R5, R4, R1, R4, R2, L1, R4, L1, L4, L5, L4, R4, R5, R1, L2, L4, L1, L5, L3, L5, R2, L5, R4, L4, R3, R3, R1, R4, L1, L2, R2, L1, R4, R2, R2, R5, R2, R5, L1, R1, L4, R5, R4, R2, R4, L5, R3, R2, R5, R3, L3, L5, L4, L3, L2, L2, R3, R2, L1, L1, L5, R1, L3, R3, R4, R5, L3, L5, R1, L3, L5, L5, L2, R1, L3, L1, L3, R4, L1, R3, L2, L2, R3, R3, R4, R4, R1, L4, R1, L5"

movementTracker = (commands)->
  orientation = 0
  xPosition = 0
  yPosition = 0

  bearing = (orientation)->
    if orientation % 4 == 0
      'N'
    else if orientation % 4 == 1
      'E'
    else if orientation % 4 == 2
      'S'
    else
      'W'

  # For Part Two
  locations = [[0,0]]
  repeatedPosition = undefined
  hasDuplicateLocation = (oldLocations, newLocation)->
    flag = false
    oldLocations.forEach (oldLocation)->
      if oldLocation[0] == newLocation[0] && oldLocation[1] == newLocation[1]
        flag = true
    flag

  commands.split(", ").forEach (command)->
    rotation = if command[0] == 'R' then 1 else -1
    orientation += rotation
    orientation += 4 if orientation < 0
    currentBearing = bearing(orientation)
    distance = parseInt(command[1..-1])

    # for Part Two
    unless repeatedPosition
      for i in [1..distance]
        intermediatePosition =
          switch currentBearing
            when 'N' then [xPosition + i, yPosition]
            when 'E' then [xPosition, yPosition + i]
            when 'S' then [xPosition - i, yPosition]
            when 'W' then [xPosition, yPosition - i]
        if hasDuplicateLocation(locations, intermediatePosition) && !repeatedPosition
          repeatedPosition = intermediatePosition
        else
          locations.push(intermediatePosition)

    switch currentBearing
      when 'N' then xPosition += distance
      when 'E' then yPosition += distance
      when 'S' then xPosition -= distance
      when 'W' then yPosition -= distance

  # Part One
  blocksFromStart = Math.abs(xPosition) + Math.abs(yPosition)
  console.log("Endpoint is #{blocksFromStart} blocks from start")

  # Part Two
  repeatedBlocks = Math.abs(repeatedPosition[0]) + Math.abs(repeatedPosition[1])
  console.log("First repeated position is #{repeatedBlocks} blocks from start")

movementTracker(input)

