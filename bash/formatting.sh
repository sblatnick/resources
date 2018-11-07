#::::::::::::::::::::FORMATTING::::::::::::::::::::

echo -e "text" #allows escape sequences like colors (see COLORED OUTPUT)
echo -n "text" #skips newline at end

#printf:
  printf $FORMAT parameters
  #types:
  # %s    string
  # %d    digit, same as %i
  # %f    float
  # %b    string containing escape sequences
  # %q    shell quoted

  #padding (works for %s and %f):
  # %-4s  left aligned, reserving 4 spaces for a column
  # %4s   right aligned, reserving 4 spaces for a column
  # %.3s  %s: truncated to 3 characters/digits
  #       %f: precision after decimal

  #* means take the argument before as the length:
  printf "%*s\n" 10 "10 width"

  #0 first means pad with 0s (doesn't work with - for left alignment):
  printf "%06.2f\n" 56.1
    056.10
    #meaning:
      #6 chars counting decimial
      #padded with 0s to the left
      #accuracy of 2 decimal points

  #add commas to numbers:
  printf "%'d\n" "1000000000"
    1,000,000,000

  #coloring (see COLORED OUTPUT):
    #be sure to separate color tags from strings if you don't want
    #the escape sequences to effect the string length for creating columns:
    FORMAT="%b%-4.4s%b\n"
    printf "$FORMAT" "\033[31m" "in red left aligned reserving a minimum of 4 chars, truncated to 4 chars" "\033[0m"

  #see also: http://wiki.bash-hackers.org/commands/builtin/printf

#::::::::::::::::::::WHITESPACE::::::::::::::::::::

#trim down the leftmost tab-space to 2 spaces in your usage documentation:
  echo "Usage: ${PROG} [--parameter arg]
  Parameters:
    --option [value]                           Specify value
    --help|-h                                  Print this help information
  " | expand -i -t 2

#Change indentation width in printed output:
  tabs 4

#args on newlines:
  echo "args:  $(xargs -n 1 <<< "$@")"
#args with whitespace trimmed to one:
  echo "args:  $(xargs <<< "$@")"

#::::::::::::::::::::COMBINE COLUMNS::::::::::::::::::::

#merge lines of a file:
  pr -mts' ' file1 file2
  paste -d' ' file1 file2


