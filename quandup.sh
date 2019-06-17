#/bin/bash
clear
read -p "How many nodes to install?" VAR
ipreq="$VAR"
echo "Current list of IP addresses"
dupmn iplist

read -p "Enter starting IPV6 Address: " IPVAR

iptrunc=${IPVAR%:*}":"

read -p "Number of First Node?: " DUPNUM

counter="$DUPNUM"
while [ $counter -le $ipreq ]
do
  dupmn install quantisnet -bootstrap -ip="$iptrunc$counter"
  ((counter++))
done

echo ALL done
