#/bin/bash
clear
read -p "How many IPV6 IP Addresses do you need?" VAR
read -p "Enter starting IPV6 Address: " IPVAR
ipreq = $VAR
ipstart = $IPVAR

counter = 1
while [ $counter -le $ipreq ]
do
  dupmn ipadd $ipstart 64 eth0
  ((counter++))
done

echo ALL done

