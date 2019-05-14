#!/bin/bash
cd ~
quantisnet-cli stop
killall -9 quantisnetd
cd /usr/local/bin
rm quantisnetd quantisnet-cli quantisnet-tx test_quantisnet quantisnet-qt
while true; do
  read -p "Enter URL for new wallet .tar.gz:" url
  case %url in
    [http]* ) wget url; break;;
    * ) echo "Please enter a valid URL.";;
  esac
done


