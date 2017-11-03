#!/bin/sh
#Oinkmaster for Suricata ruleset

echo "*] Updating ..."
sudo apt-get update

echo "*] Installing Oinkmaster ..."
sudo apt-get install oinkmaster

echo "*] Configuring /etc/oinkmaster.conf"
sudo cp oinkmaster.conf /etc/oinkmaster.conf
sudo mkdir /etc/suricata/rules

echo "*] Run oinkmaster to download rules ..."
echo "*] Downloading ..."
sudo oinkmaster -C /etc/oinkmaster.conf -o /etc/suricata/rules
ls /etc/suricata/

echo "*] Edit classification-file: /etc/suricata/rules/classification.config"
echo "*] reference-config-file: /etc/suricata/rules/reference.config"
sudo nano /etc/suricata/suricata.yaml

echo "*] Done ..."