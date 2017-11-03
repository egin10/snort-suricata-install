#!/bin/sh
#installing Suricata for IDS mode

echo "*] installing Suricata for IDS mode  ..."
cd suricata
pwd
echo "*] Updating ..."
sudo apt-get update -y

echo "*] Install all the dependencies ..."
sudo apt-get install libpcre3-dbg libpcre3-dev autoconf automake libtool libpcap-dev libnet1-dev libyaml-dev zlib1g-dev libcap-ng-dev libmagic-dev libjansson-dev libjansson4 libnetfilter-queue-dev libnetfilter-queue1 libnfnetlink-dev

echo "*] Installing suricata suricata-4.0.1 ..."
tar -xzvf suricata-4.0.1.tar.gz
cd suricata-4.0.1
sudo ./configure --enable-nfqueue --prefix=/usr --sysconfdir=/etc --localstatedir=/var
sudo make
sudo make install
sudo make install-conf

echo "*] Installing suricata for IDS mode ..."
sudo make install-rules
ls /etc/suricata/rules

echo "*] Installing Oinkmaster ruleset ..."
./oinkmaster.sh

echo "# Configure IP Address..."
# sudo nano /etc/suricata/suricata.yaml
nano suricata.yaml.in

echo "# Configure /etc/suricata/suricata.yaml for IP Address, rules and Log ..."
sudo cp suricata.yaml.in suricata.yaml
sudo cp /etc/suricata/suricata.yaml /etc/suricata/suricata.yaml.save
sudo rm -rf /etc/suricata/suricata.yaml
sudo cp suricata.yaml /etc/suricata/suricata.yaml
cd ..
echo "*] Done ..."
