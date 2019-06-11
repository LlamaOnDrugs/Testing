#/bin/bash
clear
read -p "How many masternodes did you install?" VAR

jobcount="$VAR"
srcdir=/root/.quantisnetcore
sentdir=/sentinel/
  
counter=1
while [$counter -le $jobcount ]
do

  #write out current crontab
  crontab -l > mycron
  #echo new cron into cron file
  echo "*/5 * * * * cd ${srcdir}${counter}${sentdir} && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1" >> mycron
  #install new cron file
  crontab mycron
  rm mycron
done
