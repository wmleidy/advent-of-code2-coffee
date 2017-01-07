# INPUT
# Disc #1 has 13 positions; at time=0, it is at position 11.
# Disc #2 has 5 positions; at time=0, it is at position 0.
# Disc #3 has 17 positions; at time=0, it is at position 11.
# Disc #4 has 3 positions; at time=0, it is at position 0.
# Disc #5 has 7 positions; at time=0, it is at position 2.
# Disc #6 has 19 positions; at time=0, it is at position 17.

# Note: I thought about taking an object-oriented approach here, but
# the mathematical approach below is very simple and straightforward.

findWhenToDrop = (addSeventhDisc = false)->
  time = -1
  loop
    time++
    # to pass through a disc, time + timeOffset + startingPosition % discPositions must equal 0
    continue unless (time + 1 + 11) % 13 == 0
    continue unless (time + 2 + 0)  % 5  == 0
    continue unless (time + 3 + 11) % 17 == 0
    continue unless (time + 4 + 0)  % 3  == 0
    continue unless (time + 5 + 2)  % 7  == 0
    continue unless (time + 6 + 17) % 19 == 0
    continue unless (time + 7 + 0)  % 11 == 0 if addSeventhDisc
    break
  time

console.log(findWhenToDrop())
console.log(findWhenToDrop(true))