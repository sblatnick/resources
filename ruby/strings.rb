
#split:
  array = string.split("\n") #make sure you use double quotes, or it won't match newlines
  distro = string.split('\n')[0].strip

#substitution:
  string.sub(/regex/,'replace')  #first
  string.gsub(/regex/,'replace') #greedy

  #backreferences:
    "search".sub(/(regex)/, 'replace: \1')
  #named backreference:
    "search".sub(/(?<name>regex)/, 'replace: \k<name>')
  #act on matches oneliner:
    "search".sub(/regex/) {|match| 'replace: ' + match }

#regex capture group:
  result = string[/(\d+\.\d+)/, 1]

#interpolation:
  string = "%{result} version"
