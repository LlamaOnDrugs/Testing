#!/bin/bash
cd ~
quantisnet-cli stop
killall -9 quantisnetd
cd /usr/local/bin
read "Enter URL" VAR

wget VAR



