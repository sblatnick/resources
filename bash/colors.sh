#::::::::::::::::::::COLORED OUTPUT::::::::::::::::::::

#Colored console text:
  echo -e "\033[32mThis is green.\033[0m"
#view the file in less with coloring:
  less -R file.txt

#watch with color using -c, also print logs indenting different files and removing the pid part of log name [pid].[service]:
  watch -c "tail -n+1 13662.* | sed 's/^/  /' | sed 's/  ==> [0-9]*\.\([^ ]*\) <==/\1/'"

#watch a function:
export -f check_cfg
watch check_cfg

#print all files with file name in blue:
  tail -n +1 ${WORK}/* 2>/dev/null | sed 's/^/    /' | sed "s/  ==> ${escaped}\/\(.*\) <==/$(printf '\033[34m')\1$(printf '\033[0m')/"

#  (must close it or it will continue after)
#or in C:
#     printf("\033[34m This is blue.\033[0m\n");

#ANSI COLORS \033[%dm█\033[0m
  # FOREGROUND:
    #   30    black foreground
    #   31    red foreground
    #   32    green foreground
    #   33    yellow foreground
    #   34    blue foreground
    #   35    magenta (purple) foreground
    #   36    cyan (light blue) foreground
    #   37    gray foreground

    #   90    Dark gray
    #   91    Light red
    #   92    Light green
    #   93    Light yellow
    #   94    Light blue
    #   95    Light magenta
    #   96    Light cyan

  # BACKGROUND
    #   40    black background
    #   41    red background
    #   42    green background
    #   43    yellow background
    #   44    blue background
    #   45    magenta background
    #   46    cyan background
    #   47    white background

    #   100   Dark gray
    #   101   Light red
    #   102   Light green
    #   103   Light yellow
    #   104   Light blue
    #   105   Light magenta
    #   106   Light cyan
  # ATTRIBUTES
    #   0     reset all attributes to their defaults
    #   1     set bold
    #   5     set blink
    #   7     set reverse video
    #   22    set normal intensity
    #   25    blink off
    #   27    reverse video off

    #(the 1 after the ; is for bold in: echo -e "\033[32;1mThis is green.\033[0m")

#256 Colors: 0-255
  # FOREGROUND: 38;5; \033[38;5;%dm█\033[0m
  # BACKGROUND: 48;5; \033[48;5;%dm█\033[0m
  # BOTH:             \033[48;5;%d;38;5;%dm█\033[0m

  for i in $(seq 0 255)
  do
    printf "\033[38;5;%dm█\033[0m %03d\n" $i $i
  done

  #See: https://unix.stackexchange.com/questions/124407/what-color-codes-can-i-use-in-my-ps1-prompt

#Tail multiple logs with separate colors: https://stackoverflow.com/questions/28618785/tail-multiple-files-shown-by-separate-colors
tail -f log1 log2 | awk $'/==> log1/{print "\033[0m\033[1;33;40m";} /==> log2/{print "\033[0m\033[1;35;40m";} 1'

#Colorize: Tail colored output: https://www.baeldung.com/linux/tail-colored-output
  #multitail: browse through several files at once
    #it creates multiple windows on your console (with ncurses)
    multitail -i /var/log/messages
  #colortail basically tail but with support for colors
    #With the help of color config files you define what part of the output to print in which color.
    colortail /var/log/nginx/access.log
  #Generic Colouriser:
    grc ping -c 1 www.baeldung.com
    grcat
  #Tail with sed
    tail -f /var/log/mylog.log | sed \
      -e 's/\(.*INFO.*\)/\x1B[32m\1\x1B[39m/' \
      -e 's/\(.*ERROR.*\)/\x1B[31m\1\x1B[39m/'
  #See also: kubetail

