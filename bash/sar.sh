#SAR by minute reports of system resources:

  #cpu:
  sar
  #memory:
  sar -r

  #different days:
  sar -f /var/log/sa/sa09 # 09 = day of month zero padded
