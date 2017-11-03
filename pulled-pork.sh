#!/bin/sh
#Pulledpork for Snort ruleset

echo "*] Updating and Installing git ..."
sudo apt-get update -y
sudo apt-get install git

echo "*] Install the PulledPork pre-requisites ..."
sudo apt-get install -y libcrypt-ssleay-perl liblwp-useragent-determined-perl

echo "*] Download and install the PulledPork perl script and configuration files ..."
git clone https://github.com/shirkdog/pulledpork.git
cd pulledpork
sudo cp pulledpork.pl /usr/local/bin
sudo chmod +x /usr/local/bin/pulledpork.pl
sudo cp etc/*.conf /etc/snort

echo "*] Check that PulledPork runs by checking the version ..."
/usr/local/bin/pulledpork.pl -V

echo "*] Configuring PulledPork to Download Rulesets ..."
sudo cp /etc/snort/pulledpork.conf /etc/snort/pulledpork.conf.save
sudo rm -rf /etc/snort/pulledpork.conf
sudo cp pulledpork.conf /etc/snort/

echo "*] Running PulledPork ..."
sudo /usr/local/bin/pulledpork.pl -c /etc/snort/pulledpork.conf -l

echo "*] Check snort.rules on /etc/snort/rules/ ..."
ls /etc/snort/rules/
