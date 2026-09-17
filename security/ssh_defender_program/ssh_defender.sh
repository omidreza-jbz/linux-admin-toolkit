#!/bin/bash

YELLOW='\033[0;33m'
RESET='\033[0m'
NTFY_TOPIC="YOUR_NTFY_TOPIC"
log="${1:-/var/log/auth.log}"

tail -n 10 "$log" | grep "Failed password" |awk '{print $(NF-3)}' | sort | uniq -c| while read count ip; do
        if (("$count">2 ));then
                echo -e "${YELLOW}[THREAT DETECTED] IP: $ip Attempts: $count ${RESET}"
                curl -d "WARNING: High volume of failed SSH login attempts detected" ntfy.sh/$NTFY_TOPIC
        fi
	if [[ "$count" -gt 5 ]]; then
		if ! iptables -C INPUT -s "$ip" -j DROP 2>/dev/null ; then
			iptables -A INPUT -s "$ip" -j DROP
			curl -d "Blocked IP: $ip   After Failed SSH Login Attempt: $count" ntfy.sh/$NTFY_TOPIC
			echo "Blocked IP: $ip   After Failed SSH Login Attempt: $count" >> /var/log/ssh_defender.log
		fi
	fi
done
