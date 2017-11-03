# How to Install :
* `git clone https://github.com/egin10/snort-suricata-install.git`
* `cd snort-suricata-install`
* `chmod +rx install.sh`
* running `./install.sh`

---

# Snort 2.9.11
* config interfaces

```
# Routed subnet
auto your-interface-to-public
iface your-interface-to-public inet static
address 0.0.0.0
netmask 255.255.255.0
network 0.0.0.0
broadcast 0.0.0.255
gateway 0.0.0.0
pre-up iptables-restore < /etc/network/iptables.rules
post-up ethtool -K your-interface-to-public gro off
post-up ethtool -K your-interface-to-public lro off
 
# Host Subnet (internal network / screened subnet)
auto your-interface-to-local-A
iface your-interface-to-local-A inet static
address 0.0.0.0
netmask 255.255.255.0
network 0.0.0.0
broadcast 0.0.0.255
# no gateway required
post-up ethtool -K your-interface-to-local-A gro off
post-up ethtool -K your-interface-to-local-A lro off
 
# Management Subnet (internal network, not routed)
auto your-interface-to-local-B
iface your-interface-to-local-B inet static
address 0.0.0.0
netmask 255.255.255.0
network 0.0.0.0
broadcast 0.0.0.255
# no gateway
# snort not processing traffic on this interface, so no need to disable LRO or GRO
```
* Enable Kernel IP forwarding

>un-comment
```
#net.ipv4.ip_forward=1
```
* config rules
```
# line 45 (no spaces between IP addresses)
ipvar HOME_NET [192.168.0.0/24,176.16.0.0/24]

var RULE_PATH /etc/snort/rules                      # line 104
var SO_RULE_PATH /etc/snort/so_rules                # line 105
var PREPROC_RULE_PATH /etc/snort/preproc_rules      # line 106
 
var WHITE_LIST_PATH /etc/snort/rules/iplists        # line 113
var BLACK_LIST_PATH /etc/snort/rules/iplists        # line 114

# at line 168, add the following new lines:
config daq: nfq
config daq_mode: inline
config daq_var: queue=4

# Step #6: Configure output plugins
output unified2: filename snort.u2, limit 128
output log_tcpdump: tcpdump.log

# Step #7: Customize your rule set
add rules and look at /etc/snort/rules/
```

---

# Suricata 4.0.1
Under “vars” section, you will find several important variables used by Suricata. “HOME_NET” should point to the local network to be inspected by Suricata. “!$HOME_NET” (assigned to EXTERNAL_NET) refers to any other networks than the local network. “XXX_PORTS” indicates the port number(s) use by different services. Note that Suricata can automatically detect HTTP traffic regardless of the port it uses. So it is not critical to specify the HTTP_PORTS variable correctly.

---

# PulledPork

**Edit pulledpork.conf on line 19 & 26 and adding your oinkcode**
Anywhere you see `<oinkcode>` enter the oinkcode you received from snort.org (if you didn’t get an oinkcode, you’ll need to comment out lines 19 and 26):

```
Line 19 & 26: enter your oinkcode where appropriate (or comment out if no oinkcode)
Line 29: Un-comment for Emerging threats ruleset (not tested with this guide)
```