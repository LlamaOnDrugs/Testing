#!/bin/bash
cd ~
systemctl stop CARDbuyers.service
killall -9 CARDbuyersd
rm /usr/local/bin/CARDbuyers*
wget https://github.com/CARDbuyers/BCARD/releases/download/2.2.0/CARDbuyersd.tar.gz
tar -xvf CARDbuyersd.tar.gz -C /usr/local/bin/
rm CARDbuyersd.tar.gz
chmod 755 /usr/local/bin/CARDbuyers*
CARDbuyersd -daemon
systemctl start CARDbuyers.service
