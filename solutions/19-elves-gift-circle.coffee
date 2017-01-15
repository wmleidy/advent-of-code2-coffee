input = 3005290

handoffPresentsInOrder = (numberOfElves)->
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

console.log(handoffPresentsInOrder(input))