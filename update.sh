#!/bin/bash
cd ~
quantisnet-cli stop
killall -9 quantisnetd
cd /usr/local/bin

rm quantisnetd quantisnet-cli

read -p "Enter URL : " VAR

filename = $(basename "$VAR")
wget = "$VAR"

tar xzvf $filename

cd ~/.quantisnetcore
rm -r backups blocks chainstate database banlist.dat db.log debug.log fee_estimates.dat governance.dat mempool.dat mncache.dat mnpayments.dat netfulfilled.dat peers.dat


echo "remove wallet.dat? : "
select yn in "Yes" "No"; do
	case $yn in
		Yes ) rm wallet.dat;break;;
		No ) break;;
	esac
done

echo "remove quantisnet.conf? : "
select yn in "Yes" "No"; do
	case $yn in
		Yes ) rm quantisnet.conf;break;;
		No ) break;;
	esac
done



cd /usr/local/bin/quantisnetd -daemon -server -listen
