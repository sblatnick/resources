#!/bin/bash

#::::::::::::::::::::ZENITY::::::::::::::::::::

#Create a list to select from and use the selected result:
vm=$(zenity --list \
  --title="Terminal Environment" \
  --column="Env" \
    "vm1" \
    "vm2" \
    "vm3")
vm="${vm#*\|}"
echo "Opening $vm logs"
xfce4-terminal \
    -H -T "Apache Log" -e "ssh $user@$vm \"tail -f /var/log/error_log\"" \
    --tab -H -T "Tomcat Log" -e "ssh $user@$vm \"tail -f /var/log/tomcat\""

#multiple fields:
zenity --forms --title "Title" --add-password="PIN" --add-password="Password"

#::::::::::::::::::::YAD::::::::::::::::::::

#like zenity, but more powerful
#site: http://sourceforge.net/projects/yad-dialog/

#::::::::::::::::::::NOTIFICATION::::::::::::::::::::
notify-send [main message] [secondary message]
notify-send -i [icon file or stock name] [main message] [secondary message]

#::::::::::::::::::::WMCTRL::::::::::::::::::::

wmctrl
wmctrl -l         #list windows
wmctrl -a Firefox #focus window with this string in the title, going to the desktop
wmctrl -R Firefox #focus window with this string in the title, putting it on the current desktop

Actions:
  -m = window manager info
  -l = list windows
  -d = list desktops, active marked with *
  -s = switch to the specified desktop.
  -a <WIN> = activate the window by switching to its desktop and raising it
  -c <WIN> = close the window gracefully.
  -R <WIN> = move the window to the current desktop and activate it
  -r <WIN> -t <DESK> = move the window to the specified desktop
  -r <WIN> -e <MVARG> = resize and move the window around the desktop
  -r <WIN> -b <STARG> = change the state of the window
  -r <WIN> -N <STR> = set the name (long title) of the window
  -r <WIN> -I <STR> = set the icon name (short title) of the window
  -r <WIN> -T <STR> = set both the name and the icon name of the window
  -k (on|off) = activate or deactivate "showing the desktop" mode
  -o <X>,<Y> = change the viewport for the current desktop (from top-left)
  -n <NUM> = change number of desktops
  -g <W>,<H> = change geometry (common size) of all desktops
  -h = help
Options:
  -i = interpret <WIN> as a numerical window ID
  -p = include PIDs in the window list
  -G = include geometry in the window list
  -x = include WM_CLASS in the window list or interpret <WIN> as the WM_CLASS name
  -u = override auto-detection and force UTF-8 mode
  -F = full window title case-sensitive matching (instead of substring)
  -v = verbose
  -w <WA> = workaround
Arguments:
  <WIN> = window title (first matching), modified by options
    :SELECT: = select the window by clicking
    :ACTIVE: = currently active window
  <DESK> = desktop number (counted from zero)
  <MVARG> = change to the position and size
    format:
      <G>,<X>,<Y>,<W>,<H>
        -1 = leave unchanged (except <G>)
        <G>: gravity specified as a number, where 0 = "use the default gravity"
  <STARG> state change (_NET_WM_STATE request)
    format:
      (remove|add|toggle),<PROP1>[,<PROP2>]
    properties:
      modal, sticky, maximized_vert, maximized_horz,
      shaded, skip_taskbar, skip_pager, hidden,
      fullscreen, above, below
Workarounds:
  DESKTOP_TITLES_INVALID_UTF8 = print non-ASCII desktop titles correctly
window list format:
  <window ID> <desktop ID> <client machine> <window title>
desktop list format:
  <desktop ID> [-*] <geometry> <viewport> <workarea> <title>


#::::::::::::::::::::XDOTOOL::::::::::::::::::::
xdotool
  -supports window stack of last used windows
  -supports command chaining, where %1 is the last window used

KEYBOARD COMMANDS
  key [options] [keystroke]
  keydown [options] [keystroke]
  keyup [keystroke]
  type [options]
    --window window
    --clearmodifiers
    --delay milliseconds
  [keystroke] examples: "alt+r", "Control_L+J", "ctrl+alt+n", "BackSpace".
MOUSE COMMANDS
  mousemove [options] x y OR 'restore'
    --window WINDOW
    --screen SCREEN
    --polar (Use polar coordinates. 'x' an angle 0-360 and 'y' the distance.)
    --clearmodifiers
    --sync (wait until the mouse is actually moved)
  mousemove_relative [options] x y
    --polar
    --sync
    --clearmodifiers
  click [options] button
  mousedown [options] button
  mouseup [options] button
    --clearmodifiers
    --repeat REPEAT
    --delay MILLISECONDS
    --window WINDOW
  getmouselocation [--shell]
  behave_screen_edge [options] where command ...
    --delay MILLISECONDS
    --quiesce MILLISECONDS (before the next command will run)
    where:
      left
      top-left
      top
      top-right
      right
      bottom-left
      bottom
      bottom-right
WINDOW COMMANDS
  search [options] pattern
    --class
    --classname
    --maxdepth N
    --name
    --onlyvisible
    --pid PID
    --screen N
    --desktop N
    --limit N
    --title
    --all
    --any
    --sync
  selectwindow (get id from window clicked on)
  behave window action command ...
    mouse-enter
    mouse-leave
    mouse-click
    focus
    blur
  getwindowpid [window]
  getwindowname [window]
  getwindowgeometry [options] [window]
    --shell
  getwindowfocus [-f]
  windowsize [options] [window] width height
    --usehints
    --sync
  windowmove [options] [window] x y
    --sync
    --relative (to current position)
  windowfocus [options] [window]
    --sync
  windowmap [options] [window]
    --sync
  windowminimize [options] [window]
    --sync
  windowraise [window_id=%1]
  windowreparent [source_window] destination_window
  windowkill [window]
  windowunmap [options] [window_id=%1]
    --sync
  set_window [options] [windowid=%1]
    --name newname
    --icon-name newiconname
    --role newrole
    --classname newclassname
    --class newclass
    --overrideredirect value
DESKTOP AND WINDOW COMMANDS
    windowactivate [options] [window]
      --sync
    getactivewindow
    set_num_desktops number
    get_num_desktops
    get_desktop_viewport [--shell]
    set_desktop_viewport x y
    set_desktop [options] desktop_number
      --relative
    get_desktop
    set_desktop_for_window [window] desktop_number
    get_desktop_for_window [window]
MISCELLANEOUS COMMANDS
    exec [options] command [...] (often useful when combined with behave_screen_edge)
      --sync (Block until the child process exits.)
    sleep seconds (Fractions of seconds (like 1.3, or 0.4) are valid, here.)
xdotool SCRIPTS
  #!/usr/local/bin/xdotool
  search --onlyvisible --classname $1

  windowsize %@ $2 $3
  windowraise %@

  windowmove %1 0 0
  windowmove %2 $2 0
  windowmove %3 0 $3
  windowmove %4 $2 $3

#Examples:
  xdotool windowminimize $(xdotool getactivewindow)
  xdotool windowminimize $(xdotool search FreeRDP)
  xdotool windowminimize --sync $(xdotool search FreeRDP) #wait until minimized to move on

#::::::::::::::::::::EXAMPLES::::::::::::::::::::

xwininfo -id <windowid> | grep "Map State" #detect visibility

#Notification only if geany is not on the screen:
  width=1600
  geanyId=$(wmctrl -l | grep Geany)
  geanyId=${geanyId%% *}
  xPos=$(xwininfo -id $geanyId | grep "Absolute upper-left X:")
  xPos=${xPos##* }
  if [ $xPos -gt 0 ] || [ $xPos -le -$width ]; then
    notify-send "DEPLOYED $1"
  fi

#Fix Audacious from not focusing on the global shortcut in compiz:
  audacious -m
  id=$(wmctrl -l | grep Audacious)
  id=${id%% *}
  xdotool windowactivate $id

#Focus pidgin:
  xdotool windowactivate $(xdotool search --onlyvisible --class pidgin)

#Toggle visibility of window (use shortcut to call this script):
  #!/bin/bash
  focused=$(xdotool getwindowfocus getwindowname)
  case $focused in
    *FreeRDP*)
        xdotool windowminimize --sync $(xdotool search FreeRDP)
      ;;
    *)
        wmctrl -R 'FreeRDP'
      ;;
  esac
