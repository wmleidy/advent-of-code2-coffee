input = [
  "cpy a d"
  "cpy 4 c"
  "cpy 633 b"
  "inc d"
  "dec b"
  "jnz b -2"
  "dec c"
  "jnz c -5"
  "cpy d a"
  "jnz 0 0"
  "cpy a b"
  "cpy 0 a"
  "cpy 2 c"
  "jnz b 2"
  "jnz 1 6"
  "dec b"
  "dec c"
  "jnz c -4"
  "inc a"
  "jnz 1 -7"
  "cpy 2 b"
  "jnz c 2"
  "jnz 1 4"
  "dec b"
  "dec c"
  "jnz 1 -4"
  "jnz 0 0"
  "out b"
  "jnz a -19"
  "jnz 1 -21"
]

processInput = (input, a = 0, b = 0, c = 0, d = 0)->
  cursor = 0
  output = []

  while (cursor < input.length) and (output.length < 100)
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
    else if matchData = command.match(/out (\D)/)
      output.push(eval("Number(#{matchData[1]})"))
    cursor++

  return false if output.length != 100

  for num, idx in output
    if idx % 2 == 0 && num != 0
      return false
    else if idx % 2 == 1 && num != 1
      return false

  true

searchForMatch = ()->
  i = 1
  until processInput(input, i, 0, 0, 0)
    console.log("Checking #{i}")
    i++
  console.log("Match found with argument #{i}")

searchForMatch()