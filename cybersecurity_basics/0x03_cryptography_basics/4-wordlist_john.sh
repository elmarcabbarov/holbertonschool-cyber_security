#!/bin/bash
john --wordlist=/home/elmar/Worldlists/rockyou.txt --format=Raw-MD5 "$1" && john --show --format=Raw-MD5 "$1" | awk -F: '{print $2}' | grep -v '^$' > 4-password.txt
