#!/bin/bash
cd ~
quantisnet-cli stop
killall -9 quantisnetd
cd /usr/local/bin

read -p "Enter URL : " VAR

filename = $(basename "$VAR")
wget = "$VAR"
