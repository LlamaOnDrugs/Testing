#!/bin/bash
cd ~
quantisnet-cli stop
killall -9 quantisnetd
cd /usr/local/bin
url = https://github.com/LlamaOnDrugs/Quan/blob/master/quan-mn-update.sh
filename = $(basename "$url")
wget = "$url"
