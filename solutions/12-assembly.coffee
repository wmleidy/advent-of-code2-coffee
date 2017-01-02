input = [
  "cpy 1 a"
  "cpy 1 b"
  "cpy 26 d"
  "jnz c 2"
  "jnz 1 5"
  "cpy 7 c"
  "inc d"
  "dec c"
  "jnz c -2"
  "cpy a c"
  "inc a"
  "dec b"
  "jnz b -2"
  "cpy c b"
  "dec d"
  "jnz d -6"
  "cpy 16 c"
  "cpy 12 d"
  "inc a"
  "dec d"
  "jnz d -2"
  "dec c"
  "jnz c -5"
]

processInput = (input, a = 0, b = 0, c = 0, d = 0)->
  cursor = 0

  while cursor < input.length
    command = input[cursor]
    if matchData = command.match(/inc (.)/)
      eval("#{matchData[1]}++")
    else if matchData = command.match(/dec (.)/)
      eval("#{matchData[1]}--")
    else if matchData = command.match(/cpy (\d+) (.)/)
      eval("#{matchData[2]} = #{Number(matchData[1])}")
    else if matchData = command.match(/cpy (\D) (.)/)
      tmp = eval("#{matchData[1]}")
      eval("#{matchData[2]} = #{tmp}")
    else if matchData = command.match(/jnz (.) (.+)/)
      unless eval("#{matchData[1]} === 0")
        cursor += Number(matchData[2])
        continue
    cursor++

  console.log("Final register values: a = #{a}, b = #{b}, c = #{c}, d = #{d}")

processInput(input)
processInput(input, 0, 0, 1)