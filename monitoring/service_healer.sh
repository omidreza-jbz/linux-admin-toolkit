#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
RESET='\033[0m'
NTFY_TOPIC="YOUR_NTFY_TOPIC"
service_name="$1"

if [[ -z "$service_name" ]]; then
    while [[ -z "$service_name" ]]; do
        read -p "Enter service name to monitor: " service_name
    done
fi
if systemctl is-active --quiet "$service_name" ;then
	echo -e "${GREEN}[OK] Service  is running smoothly.${RESET}"
else
	echo -e "Service is down\n Attempting To Restart It"
	curl -d "WARNING: Service $service_name is down. Attempting restart..." ntfy.sh/$NTFY_TOPIC
	systemctl restart "$service_name"
	sleep 3
	if systemctl is-active --quiet "$service_name";then
		echo -e "${GREEN}Service Recovered${RESET}"
		curl -d "SUCCESS: Service $service_name recovered successfully." ntfy.sh/$NTFY_TOPIC
	else
		curl -d "CRITICAL: Service $service_name failed to recover after restart!" ntfy.sh/$NTFY_TOPIC
	fi
fi

