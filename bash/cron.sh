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