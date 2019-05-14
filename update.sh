#!/bin/bash
cd ~
quantisnet-cli stop
killall -9 quantisnetd
cd /usr/local/bin
rm quantisnetd quantisnet-cli quantisnet-tx test_quantisnet quantisnet-qt

read "Enter URL" VAR

wget VAR



