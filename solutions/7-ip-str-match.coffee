file = "../input/input7.txt"
fs = require('fs')

countValidTPS = ()->
  count = 0
  for line in fs.readFileSync(file, 'utf8').split("\n")
    if line.match(/\[\w*([a-z])([a-z])\2\1\w*\]/)
      continue
    extractedString = line.replace(/\[\w*\]/g, "*")
    matchData = extractedString.match(/([a-z])([a-z])\2\1/)
    count++ if matchData? and matchData[1] != matchData[2]
    # count++ if extractedString.match(/([a-z])(?!\1)([a-z])\2\1/) # one-line lookahead version
  count

# as far as I personally got on a regex solution to Part Two (...close but no cigar...)

# countValidSSLFail = ()->
#   count = 0
#   for line in fs.readFileSync(file, 'utf8').split("\n")
#     matchData1 = line.match(/([a-z])([a-z])\1\w*\[\w*\2(?!\2)\1\2\w*\]/)
#     matchData2 = line.match(/\[\w*([a-z])([a-z])\1\w*\].*?\2(?!\2)\1\2/)
#     count++ if (matchData1? or matchData2?)
#   count

strCrawlingSolution = ()->
  count = 0
  for line in fs.readFileSync(file, 'utf8').split("\n")
    str = line.replace(/\[.*?\]/g, "*")
    matches = []
    for i in [0..(str.length - 2)]
      if str[i] == str[i+2] && str[i] != str[i+1] && str[i+1] != "*"
        testStr = "#{str[i+1]}#{str[i]}#{str[i+1]}"
        matches.push(testStr)
      i++

    segments = line.replace(/[\[\]]/g, "*").split("*")
    bracketSegments = (segment for segment, i in segments when i % 2 is 1) # take only odd-indexed groups
    flag = false
    for testStr in matches
      for segment, i in bracketSegments
        flag = true if segment.match(testStr)
    count++ if flag
  count

# working regex solution from the subreddit (without using lookbehinds, which JS doesn't support)

countValidSSL = ()->
  count = 0
  for line in fs.readFileSync(file, 'utf8').split("\n")
    matchData1 = line.match(/((\[[a-z]\])+|^[a-z]*|][a-z]*)(([a-z])(?!\4)([a-z])\4).*\[[a-z]*(\5\4\5)[a-z]*\]/)
    matchData2 = line.match(/\[[a-z]*(([a-z])(?!\2)([a-z])\2)[a-z]*\](.*\])*[a-z]*(\3\2\3)/)
    count++ if (matchData1? or matchData2?)
  count

console.log(countValidTPS())
console.log(strCrawlingSolution())
console.log(countValidSSL())