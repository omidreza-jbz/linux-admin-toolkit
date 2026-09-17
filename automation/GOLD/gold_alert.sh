#!/bin/bash

gold_price="11"

# Change this to your preferred log path
log_file="/var/log/gold_monitor.log"

api_addr=https://dummyjson.com/products/1
#api_key="YOUR_API_KEY_HERE"
alart_sent="false"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

echo -e "${YELLOW}Starting XAUUSD Monitor... Target Alert: >"$gold_price"${RESET}"

while true; do
	
	price=$(curl --max-time 10 -s -X GET "$api_addr" | jq -r '.price')

	if [[ -z "$price" || "$price" == "null" ]]; then
	
		echo -e "${RED}[ERROR] Failed to fetch data. Retrying in 60 seconds...${RESET}"
		sleep 60
		continue
	fi
	timestamp=$(date '+%Y-%m-%d %H:%M:%S')
	
	echo "$timestamp XAUUSD: $price" >> "$log_file"
	if (( $(echo "$price >= $gold_price" | bc -l) )); then
		if [[ "$alart_sent" == "false" ]];then
			echo -e "${RED}ALERT! Price reached target! Current: $price ${RESET}"
			notify-send "📈 Gold Alert!" "Target reached.\nCurrent Price: $price"
			alart_sent="true"
		else
			echo -e "[$timestamp] Target already breached. Current Price:$price"
		fi
	else
		echo -e "[$timestamp] Market Normal. Current Price:$price"
		alart_sent=false
	fi
	sleep 60
done
