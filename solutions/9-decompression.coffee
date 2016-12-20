file = "../input/input9.txt"
fs = require('fs')

unzipOne = (str)->
  characterCount = 0
  while matchData = str.match(/\((\d+)x(\d+)\)/)
    characterCount += (Number(matchData[1]) * Number(matchData[2]) + matchData.index)
    endingIndex = matchData.index + matchData[0].length + Number(matchData[1])
    str = str[endingIndex..-1]
  characterCount += str.length
  characterCount

console.log(unzipOne(fs.readFileSync(file, 'utf8')))