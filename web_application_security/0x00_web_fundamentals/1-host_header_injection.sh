#!/bin/bash
curl -s -X POST -H "Host: $1" "$2" -d "$3"
