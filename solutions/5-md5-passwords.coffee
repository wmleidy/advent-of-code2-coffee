input = 'uqwqemis'

# Note: Using https://github.com/emn178/js-md5 for md5 functionality
md5 = require('js-md5')

determinePasscode = (input)->
  integer  = 0
  passcode = ""
  until passcode.length == 8
    testStr = input + integer++
    hex = md5(testStr)
    if hex[0..4] == '00000'
      passcode += hex[5]
  passcode

console.log("First passcode: #{determinePasscode(input)}")

determineSecondPasscode = (input)->
  integer  = 0
  passcode = []
  numbersAssigned = 0
  until numbersAssigned == 8
    testStr = input + integer++
    hex = md5(testStr)
    if hex[0..4] == '00000'
      if /[0-7]/.test(hex[5]) && !passcode[hex[5]]?
        passcode[hex[5]] = hex[6]
        numbersAssigned++
  passcode.join("")

console.log("Second passcode: #{determineSecondPasscode(input)}")
