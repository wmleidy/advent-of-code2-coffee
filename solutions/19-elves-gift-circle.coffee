input = 3005290

# First solution to Part One (confusing and not very DRY)
handoffPresents = (totalElves)->
  # since we don't care how many presents an elf has, just whether they
  # have any, we can just use a boolean to represent this for simplicity
  elves = (true for i in [1..totalElves])
  elfNumber = 0
  loop
    if elves[elfNumber] # i.e. the elf has a present
      nextElf = safeIncrement(elfNumber, totalElves)
      until elves[nextElf] # i.e. the next elf that has a present
        nextElf = safeIncrement(nextElf, totalElves)
      return elfNumber + 1 if elfNumber is nextElf # +1 because array is zero-indexed
      elves[nextElf] = false
      elfNumber = safeIncrement(nextElf, totalElves)
    else
      elfNumber = safeIncrement(elfNumber, totalElves)

safeIncrement = (index, length)->
  if index == length then 0 else index + 1

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
    # originally wanted to remove the elf from array here, but it's
    # super expensive to use splice in JavaScript on a 3 million
    # element array, so ended up with a solution that resembles above
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