DISK_LENGTH = 272
input = "11101000110010100"

expandData = (a)->
  return a if a.length >= DISK_LENGTH
  b = ""
  for i in [(a.length - 1)..0]
    if a[i] == '0'
      b += '1'
    else
      b += '0'
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