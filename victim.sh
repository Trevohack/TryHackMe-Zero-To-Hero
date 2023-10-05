#!/bin/bash

while getopts ":i:" opt; do
  case $opt in
    i) IP="$OPTARG" ;;
  esac 
done 

if [ -z "$IP" ]; then
  echo "Are you dumb? : $0 -i 'The machine IP'"
  exit 1
fi

echo "Saving IP in your victim list!"
echo "VMIP='"$IP"'" >> ~/.zshrc 
