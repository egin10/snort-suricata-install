#!/bin/sh
#Installing Snort for IPS mode

echo "*] Installing Snort for IPS mode ..."
cd snort
pwd
echo "*] Config your interface, please ..."
sudo nano /etc/network/interfaces

echo "*] Configuring /etc/sysctl.conf for Firewall ..."
sudo nano /etc/sysctl.conf

echo "*] Updating ..."
sudo apt-get update -y

echo "*] Installing all pre-requisites for Snort ..."
sudo apt-get install -y build-essential libpcap-dev libpcre3-dev libdumbnet-dev bison flex zlib1g-dev liblzma-dev openssl libssl-dev
sudo apt-get install -y libnghttp2-dev
echo "*] Installing for NFQ specific libraries ..."
sudo apt-get install libnetfilter-queue-dev

echo "*] Install DAQ-2.0.6 ..."
tar -xvzf daq-2.0.6.tar.gz
cd daq-2.0.6
./configure
make
cd ..
echo "*] Done ..."

echo "*] Installing Snort snort-2.9.11 ..."
tar -xvzf snort-2.9.11.tar.gz
cd snort-2.9.11
./configure --enable-sourcefire
make
sudo make install
sudo ldconfig
sudo ln -s /usr/local/bin/snort /usr/sbin/snort
snort -V
snort --daq-list

echo "*] Configuring Snort ..."
sudo groupadd snort
sudo useradd snort -r -s /sbin/nologin -c SNORT_IDS -g snort
echo "*] Create the Snort directories ..."
sudo mkdir /etc/snort
sudo mkdir /etc/snort/rules
sudo mkdir /etc/snort/rules/iplists
sudo mkdir /etc/snort/preproc_rules
sudo mkdir /usr/local/lib/snort_dynamicrules
sudo mkdir /etc/snort/so_rules

echo "*] Create some files that stores rules and ip lists ..."
sudo touch /etc/snort/rules/iplists/black_list.rules
sudo touch /etc/snort/rules/iplists/white_list.rules
sudo touch /etc/snort/rules/local.rules
sudo touch /etc/snort/sid-msg.map

echo "*] Create our logging directories ..."
sudo mkdir /var/log/snort
sudo mkdir /var/log/snort/archived_logs

echo "*] Adjust permissions ..."
sudo chmod -R 5775 /etc/snort
sudo chmod -R 5775 /var/log/snort
sudo chmod -R 5775 /var/log/snort/archived_logs
sudo chmod -R 5775 /etc/snort/so_rules
sudo chmod -R 5775 /usr/local/lib/snort_dynamicrules

echo "Change Ownership on folders ..."
sudo chown -R snort:snort /etc/snort
sudo chown -R snort:snort /var/log/snort
sudo chown -R snort:snort /usr/local/lib/snort_dynamicrules

echo "*] Extracting Snort tarball to the snort configuration folder ..."
cd etc/
sudo cp *.conf* /etc/snort
sudo cp *.map /etc/snort
sudo cp *.dtd /etc/snort
cd ..
echo pwd
cd src/dynamic-preprocessors/build/usr/local/lib/snort_dynamicpreprocessor/
sudo cp * /usr/local/lib/snort_dynamicpreprocessor/
cd ../../../../../../../
echo pwd
echo "*] Copy snort.conf to /etc/snort/snort.conf"
sudo cp /etc/snort/snort.conf /etc/snort/snort.conf.save
sudo rm -rf /etc/snort/snort.conf
sudo cp snort.conf /etc/snort/snort.conf
cd ..

echo "*] Installing PulledPork ..."
./pulled-pork.sh

echo "*] Test Run ..."
sudo snort -T -c /etc/snort/snort.conf -Q

echo "*] Check Firewall configuration on iptables ..."
sudo iptables -L
echo "*] Configuring iptables to the FORWARD chain ..."
#sudo iptables -I FORWARD -j NFQUEUE --queue-num=4
sudo iptables -R FORWARD 1 -j NFQUEUE --queue-num=4 --queue-bypass

echo "*] Run Snort ..."
sudo snort -A console -q -u snort -g snort -c /etc/snort/snort.conf -Q
echo "*] Saving configuration iptables to /etc/network/iptables.rules"
sudo sh -c "iptables-save > /etc/network/iptables.rules"

cd ..
echo "*] Done ..."