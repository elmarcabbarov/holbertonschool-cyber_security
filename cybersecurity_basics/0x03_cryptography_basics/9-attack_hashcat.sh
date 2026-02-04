#!/bin/bash
hashcat -m 0 --show "$1" $(hashcat -m 0 -a 1 "$1" wordlist1.txt wordlist2.txt --force > /dev/null 2>&1) | cut -d: -f2 > 9-password.txt
