#/bin/bash
clear
counter=1
ipreq=380
while [ $counter -le $ipreq ]
do
  quantisnetd -daemon -conf=/root/.quantisnetcore"$counter"/quantisnet.conf -datadir=/root/.quantisnetcore"$counter"
  ((counter++))
done

echo ALL done
