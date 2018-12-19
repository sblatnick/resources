#!/bin/bash

#source: http://www.unixcl.com/2009/12/linux-dialog-utility-short-tutorial.html

Usage: dialog <options> { --and-widget <options> }
where options are "common" options, followed by "box" options

Special options:
  [--create-rc "file"]
Common options:
  [--ascii-lines] [--aspect <ratio>] [--backtitle <backtitle>]
  [--begin <y> <x>] [--cancel-label <str>] [--clear] [--colors]
  [--column-separator <str>] [--cr-wrap] [--default-item <str>]
  [--defaultno] [--exit-label <str>] [--extra-button]
  [--extra-label <str>] [--help-button] [--help-label <str>]
  [--help-status] [--ignore] [--input-fd <fd>] [--insecure]
  [--item-help] [--keep-tite] [--keep-window] [--max-input <n>]
  [--no-cancel] [--no-collapse] [--no-kill] [--no-label <str>]
  [--no-lines] [--no-ok] [--no-shadow] [--nook] [--ok-label <str>]
  [--output-fd <fd>] [--output-separator <str>] [--print-maxsize]
  [--print-size] [--print-version] [--quoted] [--separate-output]
  [--separate-widget <str>] [--shadow] [--single-quoted] [--size-err]
  [--sleep <secs>] [--stderr] [--stdout] [--tab-correct] [--tab-len <n>]
  [--timeout <secs>] [--title <title>] [--trace <file>] [--trim]
  [--version] [--visit-items] [--yes-label <str>]
Box options:
  --calendar     <text> <height> <width> <day> <month> <year>
  --checklist    <text> <height> <width> <list height> <tag1> <item1> <status1>...
  --dselect      <directory> <height> <width>
  --editbox      <file> <height> <width>
  --form         <text> <height> <width> <form height> <label1> <l_y1> <l_x1> <item1> <i_y1> <i_x1> <flen1> <ilen1>...
  --fselect      <filepath> <height> <width>
  --gauge        <text> <height> <width> [<percent>]
  --infobox      <text> <height> <width>
  --inputbox     <text> <height> <width> [<init>]
  --inputmenu    <text> <height> <width> <menu height> <tag1> <item1>...
  --menu         <text> <height> <width> <menu height> <tag1> <item1>...
  --mixedform    <text> <height> <width> <form height> <label1> <l_y1> <l_x1> <item1> <i_y1> <i_x1> <flen1> <ilen1> <itype>...
  --mixedgauge   <text> <height> <width> <percent> <tag1> <item1>...
  --msgbox       <text> <height> <width>
  --passwordbox  <text> <height> <width> [<init>]
  --passwordform <text> <height> <width> <form height> <label1> <l_y1> <l_x1> <item1> <i_y1> <i_x1> <flen1> <ilen1>...
  --pause        <text> <height> <width> <seconds>
  --progressbox  <height> <width>
  --radiolist    <text> <height> <width> <list height> <tag1> <item1> <status1>...
  --tailbox      <file> <height> <width>
  --tailboxbg    <file> <height> <width>
  --textbox      <file> <height> <width>
  --timebox      <text> <height> <width> <hour> <minute> <second>
  --yesno        <text> <height> <width>

Auto-size with height and width = 0. Maximize with height and width = -1.
Global-auto-size if also menu_height/list_height = 0.

Get result via 2>/dev/shm/file

#Example:
dialog
  --title "A sample application"
  --menu "Please choose an option:" 15 55 5
  1 "View the config file"
  2 "Edit config file"
  3 "Exit from this menu"
  2> /dev/shm/t