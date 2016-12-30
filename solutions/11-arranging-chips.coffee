# INPUT
# The first floor contains a thulium generator, a thulium-compatible microchip, a plutonium generator, and a strontium generator.
# The second floor contains a plutonium-compatible microchip and a strontium-compatible microchip.
# The third floor contains a promethium generator, a promethium-compatible microchip, a ruthenium generator, and a ruthenium-compatible microchip.
# The fourth floor contains nothing relevant.

# Following a suggestion on the Advent of Code subreddit found here:
# https://www.reddit.com/r/adventofcode/comments/5hp9mn/day_11_puzzle_is_dumb/db6bzag/,
# I store game state as a string consisting of the floors of the elevator and each of
# the chip/generator pairs.

# That is, "1|1&2|1&3" would represent the starting state of the given example, whereas
# "1|1&1|2&1|2&1|3&3|3&3" represents my starting input.

# Since the elements of the chips/generators do affect the uniqueness of the game state,
# it is not necessary to track which chip is which as long as they are kept in pairs,
# which allows for implementing a uniform sorting algorithm to help weed out duplicate states.

String.prototype.replaceAt = (index, char)->
  this.substr(0, index) + char + this.substr(index + char.length)

class GameState
  constructor: (@state, @floors = "4")->
    @sortState()

  getSets: ()->
    @sets ||= @state.split("|")[1..-1]

  sortState: ()->
    sortedSets = @getSets().sort (a, b)->
      if a[0] != b[0]
        a[0] - b[0] # sort first by ascending chip floor location
      else
        a[2] - b[2] # if chip floor same, sort by generator floor
    @state = @state[0..1] + sortedSets.join("|")

  isWinningState: ()->
    for set in @getSets()
      return false if set[0] != @floors or set[2] != @floors
    true

  getUnpairedChips: ()->
    @unpairedChips ||= (set[0] for set in @getSets() when set[0] != set[2])

  getGeneratorLocations: ()->
    @generatorLocations ||= (set[2] for set in @getSets())

  isValid: ()->
    for chipFloor in @getUnpairedChips()
      return false if chipFloor in @getGeneratorLocations()
    true

  possibleMoves: ()->
    elevatorFloor = @state[0]
    elevatorMoves = if elevatorFloor is "1"
      ["2"]
    else if elevatorFloor is @floors
      [(Number(elevatorFloor) - 1).toString()]
    else
      [(Number(elevatorFloor) - 1).toString(), (Number(elevatorFloor) + 1).toString()]

    thingsOnSameFloor = (idx for item, idx in @state.split("") when item is elevatorFloor and idx != 0)

    # simulate carrying every possible combination of one or two things on the elevator's floor
    combosOfThings = []
    for firstThingLocation, i in thingsOnSameFloor
      combosOfThings.push([0, firstThingLocation])
      for secondThingLocation, j in thingsOnSameFloor[i+1..-1]
        combosOfThings.push([0, firstThingLocation, secondThingLocation])

    # generate altered state strings based on carrying combinations above
    newStateStrings = []
    for newFloor in elevatorMoves
      for combo in combosOfThings
        newStr = @state
        for charIndex in combo
          newStr = newStr.replaceAt(charIndex, newFloor)
        newStateStrings.push(newStr)

    newStateStrings

game = new GameState("1|2&1|3&3|1&1|2&2|3&3")
console.log(game.possibleMoves())
