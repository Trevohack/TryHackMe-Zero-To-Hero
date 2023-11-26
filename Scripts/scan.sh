#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <target> <output_location>"
    exit 1
fi



target="$1"
output_location="$2"
echo "Scanning ports on $target..."
results=$(sudo nmap -p- --min-rate 10000 -Pn -vv -oG "$output_location" "$target" 2>&1)

if [ $? -eq 0 ]; then
    open_ports=$(echo "$results" | grep -oP '\d+/open' | cut -d'/' -f1)
    closed_ports=$(echo "$results" | grep -oP '\d+/closed' | cut -d'/' -f1)
    filtered_ports=$(echo "$results" | grep -oP '\d+/filtered' | cut -d'/' -f1)

    printf "---------------------------------- %s ------------------------------\n" "$target"
    printf "| Open   | Closed | Filtered |\n"
    printf "| %-6s | %-6s | %-8s |\n" "$open_ports" "$closed_ports" "$filtered_ports"
    printf "--------------------------------------------\n"

    echo "Scan results saved to: $output_location"
else
    echo "Error: Failed to run nmap. Please make sure it is installed and try again."
fi
