#!/usr/bin/osascript
#Example script with iTerm2 tailing logs

tell application "iTerm2"
  set table to (create window with default profile)

  set t1_1 to current session of table
  tell t1_1
    write text "tail -F /var/log/system.log"

    set t2_1 to split vertically with same profile
    tell t2_1
      is at shell prompt
      write text "tail -F /var/log/system.log"

      set t2_1 to split horizontally with same profile
      tell t2_1
        is at shell prompt
        write text "tail -F /var/log/system.log"

        set t2_1 to split horizontally with same profile
        tell t2_1
          is at shell prompt
          write text "tail -F /var/log/system.log"

        end tell
      end tell
    end tell

    set t1_2 to split horizontally with same profile
    tell t1_2
      is at shell prompt
      write text "tail -F /var/log/system.log"

      set t1_3 to split horizontally with same profile
      tell t1_3
        is at shell prompt
        write text "tail -F /var/log/system.log"

        set t1_4 to split horizontally with same profile
        tell t1_4
          is at shell prompt
          write text "tail -F /var/log/system.log"

        end tell
      end tell
    end tell
  end tell

end tell
