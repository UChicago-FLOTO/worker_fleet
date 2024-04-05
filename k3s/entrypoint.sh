#!/bin/bash

set -x

################### IP AUTO DETECTION ##################################################

# Retrieve the interface name associated with the default route
interface_name=$(ip route show default | awk '/default/ {print $5}')

if [ -z "$interface_name" ]; then
    echo "Error: Unable to determine the default interface."
    exit 1
fi

# Retrieve the first IPv4 address assigned to the determined network interface
ipv4_address=$(ip -4 addr show dev "$interface_name" | awk '/inet / {print $2; exit}')

# Remove the prefix bits from the IPv4 address
ipv4_address=$(echo "$ipv4_address" | cut -d'/' -f1)

# Retrieve the first IPv6 address assigned to the determined network interface
ipv6_address=$(ip -6 addr show dev "$interface_name" | awk '/inet6 / {print $2; exit}')

# Remove the prefix bits from the IPv6 address
ipv6_address=$(echo "$ipv6_address" | cut -d'/' -f1)

# Fail if no IPv4 address is found
if [ -z "$ipv4_address" ]; then
    echo "Error: No IPv4 address found for interface $interface_name."
    exit 1
fi

# If no IPv6 address is found, assign a dummy one
if [ -z "$ipv6_address" ]; then
    ipv6_address="fe80::1" # Assign a dummy IPv6 address
fi

echo "Detected IPv4 address for $interface_name: $ipv4_address"
echo "Detected IPv6 address for $interface_name: $ipv6_address"


#########################################################################################

# start k3s agent using tailscale
k3s agent \
    --node-name=${BALENA_DEVICE_UUID} \
    --node-ip=${ipv4_address},${ipv6_address}          

set +x
