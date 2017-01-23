# Note: this is the Josephus problem (https://en.wikipedia.org/wiki/Josephus_problem)
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
    # super expensive to use splice in JavaScript on a 3-million
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

  eliminateNextElfAcross: ()->
    until @elves[@pointer].hasPresent
      @incrementPointer()
    @banish()

  findFinalElf: ()->
    for elf in @elves
      return elf.number if elf.hasPresent

circularHandoff = (numberOfElves)->
  ec = new ElvenCircle(numberOfElves)
  while ec.nextElf()
    ec.banish()
  ec.findFinalElf()

console.log(circularHandoff(input))

# Object-oriented solution to Part Two

# Working out pattern by hand revealed that the elimination pattern always proceeds by
# ELIMINATE, ELIMINATE, SKIP OVER for elves who have presents
acrossHandoff = (numberOfElves)->
  ec = new ElvenCircle(numberOfElves)
  ec.pointer = Math.floor(numberOfElves / 2)
  length = numberOfElves

  # if length starts out as odd, need to ELIMINATE, SKIP OVER once before entering main loop
  if length % 2 == 1
    ec.eliminateNextElfAcross()
    length--
    ec.nextElf()

  loop
    # eliminate first elf with present
    ec.eliminateNextElfAcross()
    break if --length == 1

    # eliminate next elf with present
    ec.eliminateNextElfAcross()
    break if --length == 1

    # skip over next elf with present (repurposes nextElf() from Part One)
    ec.nextElf()

  ec.findFinalElf()

console.log(acrossHandoff(input))

# Looking through AoC reddit revealed there are three genres of solutions that were better than
# mine, in terms of data structures used, efficiency, or general brilliance.

# 1) Linked Lists:
# Use a circularly linked list with a delete function, find midpoint then delete, delete, skip until next = self (basically what I did above, but with an array and without true elimination); or use a doubly-linked list to keep track of next and previous and follow same sequence (or elf to be removed from circle can be determined by counting (elvesList.length // 2) nodes from "taking" elf, but big O of this says this is not nearly as efficient)

# 2) Two Queues (or Arrays):
# Divide the elves into left and right 'halves', the right half being bigger if there's an odd number.
# Current recipient is the elf at the start of the left half, so the giver to be eliminated from the circle is at the start of the right half.
# If the halves are now the same size, that means the right half used to be bigger by one; shift an elf off the start of the right half and push it on the end of the left half, to keep the halves balanced.
# That recipient is shifted off the left half and pushed on to the end of the right, so the next elf to the left becomes the recipient for the next time through.
# (explanation quoted from here--https://www.reddit.com/r/adventofcode/comments/5j4lp1/2016_day_19_solutions/dbdnz4l/)

# 3) Find Answer Pattern, Use Math: find closest power of three to target, then subtract from target, if result is less than or equal to previous power of two, we're done; otherwise, increment by 2 for how much we're over...in CoffeeScript:

findAnswerPatternAndUseMath = (numberOfElves)->
  closestPower = 3**Math.floor(Math.log(numberOfElves) / Math.log(3))
  if closestPower == numberOfElves
    numberOfElves
  else
    numberOfElves - closestPower + Math.max(numberOfElves - 2 * closestPower, 0)

console.log(findAnswerPatternAndUseMath(input))