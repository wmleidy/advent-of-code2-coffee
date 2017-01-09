# Note: 100% convinced that there are ways to do this bitwise that
# are much more elegant and much more efficient...plus there's
# assuredly a way to leverage the repeating input pattern...

# DISK_LENGTH = 272
DISK_LENGTH = 35651584
input = "11101000110010100"

expandData = (a)->
  return a if a.length >= DISK_LENGTH
  b = (
    for bit in a.split("").reverse()
      if bit == '1' then '0' else '1'
  ).join("")
  a = a + '0' + b
  expandData(a)

checksum = (input)->
  return input if input.length % 2 == 1
  compressed = ""
  for i in [0...input.length] by 2
    if input[i] == input[i + 1 ]
      compressed += "1"
    else
      compressed += "0"
  checksum(compressed)

answer = checksum(expandData(input)[0...DISK_LENGTH])
console.log(answer)