#!/bin/bash

# Ping one IP address. The wait between packets is set by the caller.
# Usage: ./ping_ip.sh [ip] [interval_seconds] [count]
#   interval_seconds  seconds between pings (default: 1)
#   count             how many pings to send (omit to ping until Ctrl+C)
# Intervals shorter than 0.2 seconds usually need root (sudo).

set -euo pipefail

is_ipv4() {
    local ip="$1"
    [[ "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] || return 1
    local octet
    IFS='.' read -r -a octets <<< "$ip"
    for octet in "${octets[@]}"; do
        (( octet >= 0 && octet <= 255 )) || return 1
    done
}

is_number() {
    [[ "$1" =~ ^[0-9]+([.][0-9]+)?$ ]]
}

ip="${1:-}"
interval="${2:-}"
count="${3:-}"

if [[ -z "$ip" ]]; then
    read -r -p "IP address: " ip
fi

if [[ -z "$interval" ]]; then
    read -r -p "Seconds between pings [1]: " interval
    interval="${interval:-1}"
fi

if ! is_ipv4 "$ip"; then
    echo "Not a valid IPv4 address: $ip" >&2
    exit 1
fi

if ! is_number "$interval" || ! awk -v n="$interval" 'BEGIN { exit !(n > 0) }'; then
    echo "Interval must be a number greater than 0 (seconds)." >&2
    exit 1
fi

# macOS and Linux both reject very short waits unless the process is root.
if awk -v n="$interval" 'BEGIN { exit !(n < 0.2) }' && [[ "$(id -u)" -ne 0 ]]; then
    echo "Intervals under 0.2 seconds need root. Re-run with sudo, or choose 0.2 or higher." >&2
    exit 1
fi

echo "Pinging $ip every ${interval}s. Press Ctrl+C to stop."

if [[ -n "$count" ]]; then
    if ! [[ "$count" =~ ^[1-9][0-9]*$ ]]; then
        echo "Count must be a positive integer." >&2
        exit 1
    fi
    ping -c "$count" -i "$interval" "$ip"
else
    ping -i "$interval" "$ip"
fi
