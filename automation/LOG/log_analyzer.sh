#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
RESET='\033[0m'


if systemctl is-active --quiet sshd ; then
	echo -e "${GREEN}[SUCCESS] service is running${RESET}"	
else
	echo -e "${RED}[ALART] service is down${RESET}"
fi
# Path to web server access log (e.g., /var/log/nginx/access.log or /var/log/apache2/access.log)
log_file=/var/log/nginx/access.log
if [[ -f "$log_file" ]] ; then
	log_line=$(wc -l < "$log_file")
	echo "Total requests logged: $log_line"
	awk '{print $1}' "$log_file"|sort|uniq -c|sort -nr
	awk '{print $9}' "$log_file"|sort|uniq -c|sort -nr|while read -r count code ; do
		if [[ "$code" == "200" ]] ; then
			echo -e "${count} ${code} ${GREEN}[SUCCESS]${RESET}"
		elif [[ "$code" == "403" ]]; then
			echo -e "${count} ${code} ${RED}[Client ERROR]${RESET}"
		elif [[ "$code" == "500" ]]; then
			echo -e "${count} ${code} ${RED}[Server ERROR]${RESET}"
		else
			echo 
		fi
	done
else
	echo -e "${RED}[ALART] Log file not found!${RESET}"
fi
