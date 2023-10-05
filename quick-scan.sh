#!/bin/bash

sudo nmap -p- --min-rate 10000 -Pn -vv --open $1
