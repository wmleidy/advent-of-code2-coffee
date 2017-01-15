input = 3005290

# First solution to Part One (confusing and not very DRY)
handoffPresents = (numberOfElves)->
  elves = (true for i in [1..numberOfElves])
  elfNumber = 0
  loop
    if elves[elfNumber]
      nextElf = elfNumber + 1
      nextElf = 0 if nextElf is numberOfElves
      until elves[nextElf]
        nextElf++
        nextElf = 0 if nextElf is numberOfElves
      return elfNumber + 1 if elfNumber is nextElf
      elves[nextElf] = false
      elfNumber = nextElf + 1
      elfNumber = 0 if elfNumber is numberOfElves
    else
      elfNumber++
      elfNumber = 0 if elfNumber is numberOfElves

console.log(handoffPresents(input))

# Second solution to Part One (object-oriented and cleaner)
class Elf
  constructor: (@number, @hasPresent = true)->

class ElvenCircle
  constructor: (count)->
    @elves = (new Elf(i) for i in [1..count])
    @pointer = 0

  incrementPointer: ()->
    if @pointer >= @elves.length - 1
      @pointer = 0
    else
      @pointer++

  banish: ()->
    @elves[@pointer].hasPresent = false

  nextElf: ()->
    until @elves[@pointer].hasPresent
      @incrementPointer()
    takingElf = @pointer

    @incrementPointer()
    until @elves[@pointer].hasPresent
      @incrementPointer()
    banishedElf = @pointer

    takingElf isnt banishedElf

  findFinalElf: ()->
    for elf in @elves
      return elf.number if elf.hasPresent

circularHandoff = (numberOfElves)->
  ec = new ElvenCircle(numberOfElves)
  while ec.nextElf()
    ec.banish()
  ec.findFinalElf()

console.log(circularHandoff(input))