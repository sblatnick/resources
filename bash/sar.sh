#SAR by minute reports of system resources:

  #cpu:
  sar
  #memory:
  sar -r

  #different days:
  sar -f /var/log/sa/sa09 # 09 = day of month zero padded

  #Show all reboots:
  for i in $(seq -f "%02g" 1 31)
  do
    file=/var/log/sa/sa$i
    if [ -f $file ];then
      day=$(stat $file -c %y | cut -d' ' -f1)
      echo "$day:"
      sar -f $file | grep 'LINUX RESTART'
    fi
  done
