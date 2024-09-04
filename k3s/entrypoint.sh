#!/bin/bash

set -x

# Function to resolve CNAME using nslookup
resolve_cname() {
    local cname="$1"
    local resolved_addresses=$(nslookup -type=A "${cname}" | awk '/^Address: / { print $2 }')
    echo "${resolved_addresses}"
}

# Resolve CNAME k3s.floto.science to get IP addresses
RESOLVED_ADDRESSES=$(resolve_cname "k3s.floto.science")

# Check if any addresses were resolved
if [ -z "${RESOLVED_ADDRESSES}" ]; then
    echo "Error: No addresses resolved for k3s.floto.science"
    exit 1
fi

# Convert resolved addresses to an array
IFS=$'\n' read -rd '' -a ADDR <<< "${RESOLVED_ADDRESSES}"

# Select a random address
RANDOM_INDEX=$((RANDOM % ${#ADDR[@]}))
RANDOM_ADDRESS="${ADDR[RANDOM_INDEX]}"

SERVER_URL="https://${RANDOM_ADDRESS}:6443"

k3s agent \
    --node-name=${BALENA_DEVICE_UUID} \
    --server=${SERVER_URL}

set +x
