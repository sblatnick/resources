
#::::::::::::::::::::DETECT PROMPT::::::::::::::::::::

#if running interactively:
if tty -s <&1; then
  colorize=' --color=always'
else #running for file output or consumption, non-interactively:
  colorize=''
fi
#Only run when interactive (example when setting terminal title):
tty -s <&1 && echo -en "\033]0;TITLE\a"
#Set title when wanting it to update on each prompt:
PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
PROMPT_COMMAND='echo -ne "\033]0;YOUR TITLE GOES HERE\007"'

#::::::::::::::::::::TERMINAL PROMPT::::::::::::::::::::

#Escape coloring effecting the buffer when changing PS1:
export PS1='\w\[\033[31m\]$\[\033[0m\] '
#WRONG: export PS1='\w\033[31m$\033[0m '
#Not escaping would cause seeminly strange buffer displacement where you are editing later on the line.
#Wrap the coloring in \[ \] to prevent it from changing the perceived length of the output.

#VARIABLES (source):
#  \d   The date, in "Weekday Month Date" format (e.g., "Tue May 26"). 
#  \h   The hostname, up to the first . (e.g. deckard) 
# \H   The hostname. (e.g. deckard.SS64.com)
# \j   The number of jobs currently managed by the shell. 
# \l   The basename of the shell's terminal device name. 
# \s   The name of the shell, the basename of $0 (the portion following the final slash). 
# \t   The time, in 24-hour HH:MM:SS format. 
# \T   The time, in 12-hour HH:MM:SS format. 
# \@   The time, in 12-hour am/pm format. 
# \u   The username of the current user. 
# \v   The version of Bash (e.g., 2.00) 
# \V   The release of Bash, version + patchlevel (e.g., 2.00.0) 
# \w   The current working directory. 
# \W   The basename of $PWD. 
# \!   The history number of this command. 
# \#   The command number of this command. 
# \$   If you are not root, inserts a "$"; if you are root, you get a "#"  (root uid = 0) 
# \nnn   The character whose ASCII code is the octal value nnn. 
# \n   A newline. 
# \r   A carriage return. 
# \e   An escape character. 
# \a   A bell character.
# \\   A backslash.

#non-printing characters:
  # echo -e to print without escaping
    # octal: \012 == newline
    # hex:   \x0a == newline
  # \[   Begin a sequence of non-printing characters. (like color escape sequences).
    #This allows bash to calculate word wrapping correctly.
  # \]   End a sequence of non-printing characters.

#Change the terminal title (or tab title) using this syntax:
echo -en "\033]0;title\a"

#::::::::::::::::::::TERMINAL NAVIGATION::::::::::::::::::::

Ctrl+r   #search history, ESC to paste the currently found entry
!       #reruns last command that uses the letter after the !
  #Example:
  !l #would run ls if it is the last command used starting with l

#::::::::::::::::::::MAN PAGES::::::::::::::::::::

#view man pages when multiples:
#`man kill` says to see signals(7), so do this:
man 7 signals

#::::::::::::::::::::OPEN TERMINALS::::::::::::::::::::

#terminal with multiple tabs from command line, hold (-H) open even when commands are complete:
  xfce4-terminal -H -e "echo hello" --tab -H -e "echo world"
  xfce4-terminal -H -T "Title 1" -e "echo hello" --tab -H -T "Title 2" -e "echo world"
#gnome/mate-terminal doesn't have the hold feature:
  mate-terminal \
    --tab-with-profile=Titleable -t "Test Log" -e "ssh $user@$host \"tail -f /var/log/test.log\"" \
    --tab-with-profile=Titleable -t "Apache" -e "ssh $user@$host \"tail -f /var/log/httpd/error_log-$host\"" \
