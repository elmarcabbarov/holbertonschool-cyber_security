#!/bin/bash
tail -n 1000 auth.log | grep "Accepted" | tail -n 1 | awk '{print $9}'
