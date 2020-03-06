#::::::::::::::::::::TERMINAL EMULATORS/TOOLS::::::::::::::::::::

  #ASCII (ncurses):
    tmux       #paneling and tabs
    screen     #leave sessions running for later

  #Group execution in GUI:
    tilix      #gtk3, linux only
    iTerm2     #OSX/Mac only
      #Group Menu:
      Shell => Broadcast Input
      #Group Shortcut Setup:
      Iterm2 => Preferences => Keys
        Command + Up/Down/Left/Right: Select Spit Pane on Up/Down/Left/Right
        Option + Right: Split Vertically with "Default" Profile
        Option + Down: Split Horizontally with "Default" Profile
        Command + Space: Select Menu Item "Broadcast Input to All Panels in Current Tab"
    cssh       #csshx on OSX/Mac
    terminator #written in java, sometimes freezes for me

  #Group Command Line Tools:
    pssh       #run command on list of hosts
    pscp       #copy to a list of hosts
