input = [
  "cpy a b"
  "dec b"
  "cpy a d"
  "cpy 0 a"
  "cpy b c"
  "inc a"
  "dec c"
  "jnz c -2"
  "dec d"
  "jnz d -5"
  "dec b"
  "cpy b c"
  "cpy c d"
  "dec d"
  "inc c"
  "jnz d -2"
  "tgl c"
  "cpy -16 c"
  "jnz 1 c"
  "cpy 81 c"
  "jnz 93 d"
  "inc a"
  "inc d"
  "jnz d -2"
  "inc c"
  "jnz c -5"
]

# Slightly modified from Day 12 to account for additional valid patterns
processInput = (input, a = 0, b = 0, c = 0, d = 0)->
  cursor = 0

  while cursor < input.length
    command = input[cursor]
    if matchData = command.match(/inc (\D)/)
      eval("#{matchData[1]}++")
    else if matchData = command.match(/dec (\D)/)
      eval("#{matchData[1]}--")
    else if matchData = command.match(/cpy ([-\d]+) (.)/)
      eval("#{matchData[2]} = #{Number(matchData[1])}")
    else if matchData = command.match(/cpy (\D) (.)/)
      tmp = eval("#{matchData[1]}")
      eval("#{matchData[2]} = #{tmp}")
    else if matchData = command.match(/jnz (.) (.+)/)
      unless eval("#{matchData[1]} === 0")
        offset = Number(matchData[2])
        offset = Number(eval("#{matchData[2]}")) if isNaN(offset)
        cursor += offset
        continue
    # New command logic
    else if matchData = command.match(/tgl (.)/)
      targetIndex = cursor + eval("#{matchData[1]}")
      targetCommand = input[targetIndex]
      if targetCommand?
        if moreMatchData = targetCommand.match(/inc (.)/)
          input[targetIndex] = "dec #{moreMatchData[1]}"
        else if moreMatchData = targetCommand.match(/dec|tgl (.)/)
          input[targetIndex] = "inc #{moreMatchData[1]}"
        else if moreMatchData = targetCommand.match(/cpy (\S+) (\S+)/)
          input[targetIndex] = "jnz #{moreMatchData[1]} #{moreMatchData[2]}"
        else if moreMatchData = targetCommand.match(/jnz (\S+) (\S+)/)
          input[targetIndex] = "cpy #{moreMatchData[1]} #{moreMatchData[2]}"
    cursor++

  console.log("Final register values: a = #{a}, b = #{b}, c = #{c}, d = #{d}")

# processInput(input, 7) # Part One
processInput(input, 12) # Part Two # this takes quite awhile to run, but run it does

# Looking at the Advent of Code reedit for this day, the proper way to do Part 2 was
# to put some key of logic in place to catch the loops caused by "jnz" and to just
# multiply to set register "a" correctly (as opposed to actually running through the
# loop b * c or b * d number of times) while zeroing out the other values (when they
# are zero, the "jnz" command will not fire and the program will proceed forward).