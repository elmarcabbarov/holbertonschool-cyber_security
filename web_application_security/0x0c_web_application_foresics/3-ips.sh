#!/bin/bash
grep "Accepted" auth.log | awk '{print $11}' | sort | uniq | wc -l
