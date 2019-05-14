#!/bin/bash
cd ~
quantisnet-cli stop
killall -9 quantisnetd
cd /usr/local/bin
rm quantisnetd quantisnet-cli quantisnet-tx test_quantisnet quantisnet-qt
read -p "Enter URL for new wallet .tar.gz:" url
wget url
