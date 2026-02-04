#!/bin/bash
hashcat -m 0 --show "$1" $(hashcat -m 0 -a 0 "$1" /elmar/home/Wordlists/rockyou.txt --force > /dev/null 2>&1) | cut -d: -f2 > 7-password.txt
