#/bin/bash
clear
read -p "How many masternodes did you install?" VAR

jobcount="$VAR"

counter=1
while [$counter =le $jobcount ]
  srcdir=/root/.quantisnetcore
  sentdir=/sentinel/
  #write out current crontab
  crontab -l > mycron
  #echo new cron into cron file
  echo "* * * * * cd ${srcdir}${counter}${sentdir} && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1" >> mycron
  #install new cron file
  crontab mycron
  rm mycron
done
