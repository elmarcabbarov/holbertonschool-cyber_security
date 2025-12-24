#!/bin/bash
whois "$1" | awk -F': ' '/^(Registrant|Admin|Tech)/{gsub(/^[ \t]+/,"",$2); if($1~/(Street)/)$2=$2" "; if($1~/(Phone Ext|Fax Ext)/ && $2=="")print $1":,"; else print $1","$2}' > "$1.csv"
