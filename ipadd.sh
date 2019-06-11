#/bin/bash
clear
read -p "How many IPV6 IP Addresses do you need?" VAR

ipreq="$VAR"

echo "Current list of IP addresses"
dupmn iplist

read -p "Enter starting IPV6 Address: " IPVAR

counter=1
while [ $counter -le $ipreq ]
do
  dupmn ipadd "$IPVAR$counter" 64 eth0
  ((counter++))
done

echo ALL done

