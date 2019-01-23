
#::::::::::::::::::::DATE MANUAL (CONDENSED)::::::::::::::::::::

date [OPTION]... [+FORMAT]

-d|--date         display time described, not 'now' 
-f|--file         like --date once for each line 
-I|--iso-8601     output date/time in ISO 8601 format, optional precision:
                    'date' (default)
                    'hours'
                    'minutes'
                    'seconds'
                    'ns'
-r|--reference    display the last modification time of file 
-R|--rfc-2822     output date and time in RFC 2822 format: "Mon, 07 Aug 2006 12:34:56 -0600"
--rfc-3339        output date and time in RFC 3339 format: "2006-08-07 12:34:56-06:00" precision:
                    'date'
                    'seconds'
                    'ns'
-s|--set          set time described by STRING 
-u|--utc          print or set Coordinated Universal Time (UTC) 

FORMAT:

  Second:
    %S    00..60
    %s    seconds since 1970-01-01 00:00:00 UTC 

    %N    nanoseconds (000000000..999999999)

  Minute:
    %M    minute (00..59)

  Hour:
    %H    00..23
    %I    01..12
    %k    space padded 0..23 %_H
    %l    space padded 1..12 %_I
    %p    AM/PM, blank if not known
    %P    am/pm

  Day:
    %a    Sun, Mon, ...
    %A    Sunday, Monday, ...
    %w    day of week (0..6); 0 is Sunday
    %u    day of week (1..7); 1 is Monday

    %d    01..31
    %e     1..31 space padded %_d

    %j    001..366 day of year

  Week of Year:
    %U    00..53 starting Sunday
    %W    00..53 starting Monday
    %V    01..53 starting Monday

    %G    1999 year of week number 
    %g    00..99 year of week number

  Month:
    %m    01..12 
    %b|%h Jan, Feb, ...
    %B    January, February, ...

  Year:
    %Y    1999
    %y    00..99
    %C    century: 19, 20 

  Time:
    %r    12-hour clock "11:11:04 PM"
    %R    24-hour %H:%M
    %T|%X 23:13:48

  DateTime:
    %c    "Thu Mar 3 23:05:25 2005"
  Date:
    %D    date: %m/%d/%y 
    %F    full: %Y-%m-%d
    %x    12/31/99

  Timezone:
    %z    +hhmm numeric time zone (e.g., -0400) 
    %:z   +hh:mm numeric time zone (e.g., -04:00) 
    %::z  +hh:mm:ss numeric time zone (e.g., -04:00:00) 
    %:::z numeric time zone with : to necessary precision (e.g., -04, +05:30) 
    %Z    alphabetic time zone abbreviation (e.g., EDT) 

  Format:
    %%    literal % 
    %n    a newline 
    %t    a tab

  FORMAT FLAGS following %:
    -    do not pad 
    _    space pad
    0    zero pad (default for numbers)
    ^    upper case
    #    opposite case

  AFTER FLAGS:
    1. field width
    2. modifier:
        E = alternate representations
        0 = numeric symbols

#::::::::::::::::::::USAGE::::::::::::::::::::

#convert from epoch:
date --date @1535130434
  Fri Aug 24 10:07:14 PDT 2018
date -d @1535130434
  Fri Aug 24 10:07:14 PDT 2018

#Time passed since last ERROR logged in McAfee Application Control:
last_log() {
  read month day year time < <(grep 'ERROR' /var/log/mcafee/solidcore/solidcore.log | tail -n 1 | grep -Po '[^\s]+ \d+ \d\d\d\d:\d\d:\d\d:\d\d' | sed 's/:/ /')
  start=$(date --date="${time} ${month} ${day} ${year}" +%s)
  end=$(date +%s)
  passed=$((end - start))
  echo "$((passed / 60)) min $(( passed % 60 )) sec"
}
export -f last_log
watch bash -c last_log #watch uses sh by default, so use bash explicitly

#watch -d "command" #shows differences highlighted


#::::::::::::::::::::NTP::::::::::::::::::::
#Network Time Protocol
yum install ntpdate
ntpdate 1.ro.pool.ntp.org

#SystemD also has a ctl script, although I still had to use ntpdate above:
timedatectl set-ntp true
#Set to local timezone:
timedatectl set-local-rtc 1
#Set to UTC:
timedatectl set-local-rtc 0
#Get information about the clock:
timedatectl
