#!/bin/sh

echo "*] Start ..."
chmod +rx snort-ips.sh && chmod +rx suricata-ids.sh && chmod +rx pulled-pork.sh

echo "*] Installing git ..."
sudo apt-get update
sudo apt-get install git

echo "*] Installing Snort, Suricata and PulledPork ..."
./snort-ips.sh
echo "*] Snort Installed ..."
./suricata-ids.sh
echo "*] Suricata Installed ..."