#!bin/bash

# The Ping Sweeper: Write a script that takes an IP subnet (e.g., 192.168.1.0/24) and uses a loop to ping every host. Output a clean list of only the IP addresses that are actively alive and responding.

# This script will take an IP address(in CIDR notation) and try to ping all of it's possible hosts to check if anything is alive
echo "please provide the IP address with it's CIDR notation(e.g., 192.168.1.0/24): "
read ip_address

# Algorithm: Convert each octate to integer > process the CIDR and change the octate intefer according to that > create the IP again
# Converting each octate to integers and store in array
ip2int() {

    
}