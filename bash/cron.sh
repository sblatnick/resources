#!/bin/bash

crontab -e

###CRON:
*     *     *   *    *        [user] command to be executed
-     -     -   -    -
|     |     |   |    |
|     |     |   |    +----- day of week (0 - 6) (Sunday=0)
|     |     |   +------- month (1 - 12)
|     |     +--------- day of month (1 - 31)
|     +----------- hour (0 - 23)
+------------- min (0 - 59)

0 Sunday
1 Monday
2 Tuesday
3 Wednesday
4 Thursday
5 Friday
6 Saturday

#cron:
  /etc/cron.d/
  /etc/crontab
  /etc/cron.*/

#Sometimes user isn't listed, depending on how the cron is set up:

#EXAMPLES:
01 * * * * root run-parts /etc/cron.hourly
01 * * * * run-parts /etc/cron.hourly


#Running a job at boot: https://www.cyberciti.biz/faq/linux-execute-cron-job-after-system-reboot/
@reboot /path/to/script


#Offset:
5-59/20 * * * * echo "Run every 20 minutes 5 minutes after the hour"
#* = 0-59 range
#offset-59/frequency
#note: must be evenly divisible by 60 to be a consistent interval:
#  */25 = 0,25,50 or 25 minutes + 25 minutes + 10 minutes


#source: https://stackoverflow.com/questions/12786410/run-cron-job-every-n-minutes-plus-offset