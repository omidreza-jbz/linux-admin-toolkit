#!/bin/bash

YELLOW='\033[0;33m'
RESET='\033[0m'

log=${1:-/var/log/secure}

tail -n 10 "$log" | grep "Failed password" |awk '{print $(NF-3)}' | sort | uniq -c| while read count ip; do
	if (("$count">2 ));then
		echo -e "${YELLOW}[THREAT DETECTED] IP: $ip Attempts: $count ${RESET}"
		curl -d "WARNING: Multiple failed SSH attempts detected from IP: $ip" ntfy.sh/YOUR_NTFY_URL_HERE
	fi
done
