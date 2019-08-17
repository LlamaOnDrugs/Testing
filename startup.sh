#!/bin/bash

# Script to install dependencies, setup initial node, wait for sync, then duplicate 29 times for 30 nodes per server.
# Will also output pasteable masternode.conf file, need only fill in the remaining TXID information and start.

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get install -y nano htop git curl
sudo apt-get install -y software-properties-common
sudo apt-get install -y build-essential libtool autotools-dev pkg-config libssl-dev
sudo apt-get install -y libboost-all-dev libzmq3-dev
sudo apt-get install -y libevent-dev
sudo apt-get install -y libminiupnpc-dev
sudo apt-get install -y autoconf
sudo apt-get install -y automake unzip
sudo add-apt-repository  -y  ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install -y libdb4.8-dev libdb4.8++-dev
sudo apt-get install -y jq

wget https://github.com/QuantisDev/QuantisNet-Core/releases/download/2.1.3.1/QuantisNetcore-2.1.3.1.-.Linux-Wallets.zip
unzip QuantisNetcore-2.1.3.1.-.Linux-Wallets.zip
rm quantisnetcore-2.1.3-i686-pc-linux-gnu.tar.gz quantisnetcore-2.1.3-arm-linux-gnueabihf.tar.gz
tar -xvzf quantisnetcore-2.1.3-x86_64-linux-gnu.tar.gz
	
mv quantisnetcore-2.1.3/bin/quantisnet* /usr/local/bin
mv quantisnetcore-2.1.3/bin/test_quantisnet /usr/local/bin
mv quantisnetcore-2.1.3/include/quantis* /usr/local/include
mv quantisnetcore-2.1.3/lib/libquantis* /usr/local/lib
mv quantisnetcore-2.1.3/share/man/man1 /usr/local/share/man/
rm -r quantisnetcore-2.1.3
rm quantisnetcore-2.1.3-x86_64-linux-gnu.tar.gz
chmod +x /usr/local/bin/quantisnet*

ufw allow 9801

declare -a NODE_IPS
for ips in $(netstat -i | awk '!/Kernel|Iface|lo/ {print $1," "}')
do
  NODE_IPS+=($(curl --interface $ips --connect-timeout 2 -s4 icanhazip.com))
done

if [ ${#NODE_IPS[@]} -gt 1 ]
  then
    echo -e "More than one IP. Please type 0 to use the first IP, 1 for the second and so on...${NC}"
    INDEX=0
    for ip in "${NODE_IPS[@]}"
    do
      echo ${INDEX} $ip
      let INDEX=${INDEX}+1
    done
    read -e choose_ip
    IP=${NODE_IPS[$choose_ip]}
else
  IP=${NODE_IPS[0]}
fi

CONF_DIR=~/.quantisnetcore/
CONF_FILE=quantisnet.conf
SENT_CONF=sentinel.conf
PORT=9801

wget https://blockbook.quantisnetwork.org/static/templates/bootstrap.zip
unzip bootstrap.zip -d /root/.quantisnetcore

mkdir -p $CONF_DIR
echo "rpcuser=user"`shuf -i 100000-10000000 -n 1` > $CONF_DIR/$CONF_FILE
echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> $CONF_DIR/$CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
echo "rpcport=9797" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "logtimestamps=1" >> $CONF_DIR/$CONF_FILE
echo "port=$PORT" >> $CONF_DIR/$CONF_FILE

quantisnetd -daemon
sleep 30
PRIVKEY=$(quantisnet-cli masternode genkey)
quantisnet-cli stop
killall -9 quantisnetd

echo "masternode=1" >> $CONF_DIR/$CONF_FILE
echo "masternodeaddr=$IP:$PORT" >> $CONF_DIR/$CONF_FILE
echo "masternodeprivkey=$PRIVKEY" >> $CONF_DIR/$CONF_FILE
echo "externalip=$IP:$PORT" >> $CONF_DIR/$CONF_FILE
echo "addnode=217.61.19.126:9801" >> $CONF_DIR/$CONF_FILE
echo "addnode=94.177.245.84:9801" >> $CONF_DIR/$CONF_FILE
echo "addnode=2a02:c207:2027:7176::73:9801" >> $CONF_DIR/$CONF_FILE
echo "addnode=34.242.113.143:9801" >> $CONF_DIR/$CONF_FILE
echo "addnode=2a03:b0c0:3:e0::2cd:f002:9801" >> $CONF_DIR/$CONF_FILE
echo "addnode=2600:3c02::f03c:91ff:feda:cc80:9801" >> $CONF_DIR/$CONF_FILE

function conf_set_value() {
	# <$1 = conf_file> | <$2 = key> | <$3 = value> | [$4 = force_create]
	#[[ $(grep -ws "^$2" "$1" | cut -d "=" -f1) == "$2" ]] && sed -i "/^$2=/s/=.*/=$3/" "$1" || ([[ "$4" == "1" ]] && echo -e "$2=$3" >> $1)
	local key_line=$(grep -ws "^$2" "$1")
	[[ "$(echo $key_line | cut -d '=' -f1)" =~ "$2" ]] && sed -i "/^$2/c $(echo $key_line | grep -oP '^[\s\S]{0,}=[\s]{0,}')$3" $1 || $([[ "$4" == "1" ]] && echo -e "$2=$3" >> $1)
}
function conf_get_value() {
	# <$1 = conf_file> | <$2 = key> | [$3 = limit]
	[[ "$3" == "0" ]] && grep -ws "^$2" "$1" | cut -d "=" -f2 || grep -ws "^$2" "$1" | cut -d "=" -f2 | head $([[ ! $3 ]] && echo "-1" || echo "-$3")
}

cd $CONF_DIR
sudo apt-get update
sudo apt-get -y install python-virtualenv
sudo apt-get -y install virtualenv
user="$(whoami)"
git clone https://github.com/QuantisDev/sentinel && cd sentinel
sudo virtualenv ./venv
sudo ./venv/bin/pip install -r requirements.txt
srcdir="$(pwd)"
$(conf_set_value $CONF_DIR/sentinel/sentinel.conf "quantisnet_conf"           "${CONF_DIR}quantisnet.conf" 1)
  
#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "* * * * * cd ${srcdir} && sudo ./venv/bin/python bin/sentinel.py >/dev/null 2>&1" >> mycron
#install new cron file
crontab mycron
rm mycron

echo -e "[Unit]\
	\nDescription=QuantisNet service\
	\nAfter=network.target\
	\n\
	\n[Service]\
	\nUser=root\
	\nGroup=root\
	\nType=forking\
	\nExecStart=quantisnetd -daemon -conf=/root/.quantisnetcore/quantisnet.conf -datadir=/root/.quantisnetcore/
	\nExecStop=quantisnet-cli -conf=/root/.quantisnetcore/quantisnet.conf -datadir=/root/.quantisnetcore stop\
	\nRestart=always\
	\nPrivateTmp=true\
	\nTimeoutStopSec=60s\
	\nTimeoutStartSec=10s\
	\nStartLimitInterval=120s\
	\nStartLimitBurst=5\
	\n\
	\n[Install]\
	\nWantedBy=multi-user.target" > /etc/systemd/system/quantisnet.service

killall -9 quantisnetd

quantisnetd -daemon -datadir="/root/.quantisnetcore"

BLOCKCOUNT=$(curl -s 'https://blockbook.quantisnetwork.org/api/' | jq -r '.backend.blocks')

i="0"
while [ $i -lt 1 ]; do
	SYNCAMOUNT=$(sudo quantisnet-cli getinfo | grep -w blocks | grep -Eo '[0-9\.]+')
	if [[ $SYNCAMOUNT == $BLOCKCOUNT ]]; then
		i="1"
	else
		sleep 30
	fi
done
