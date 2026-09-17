#!/bin/bash

NTFY_TOPIC="YOUR_NTFY_TOPIC"
detect_top_proccess(){
	top -bn 1 -o %CPU | awk 'NR>7 && $1 ~ /^[0-9]+$/ {print $1, $9, $NF}'|while read pid_n cpu_usage proccess_name; do
		if [[ "$(echo "$cpu_usage > 40"|bc -l)" -eq 1 ]] ;then
			curl -d "High CPU Threat! Proccess : $pid_n is using $cpu_usage" ntfy.sh/NTFY_TOPIC
			kill -15 "$pid_n"
			sleep 5
			if kill -0 "$pid_n" 2>/dev/null ;then
				kill -9 "$pid_n"
				sleep 5
			fi
			if kill -0 "$pid_n" 2>/dev/null; then
				echo "The Proccess is Unkillable"
				curl -d "ALERT: Failed to terminate PID" ntfy.sh/NTFY_TOPIC
			else
				echo -e "SUCCESS: Process terminated successfully.\nProccess PID: $pid_n Usage Of The CPU: $cpu_usage" >> /var/log/sential.log
				date >> /var/log/sential.log;echo -e "\n" >> /var/log/sential.log
				curl -d "SUCCESS: High-load process terminated successfully." ntfy.sh/NTFY_TOPIC
			fi
		fi
	done
}
check_zombie(){
	local zombie_finder=$(ps aux | awk '$8 ~ /Z/' | wc -l)
	if (("$zombie_finder > 0"));then
		curl -d "OH OH Boss We Unfortunately Found a Zombie Proccess"ntfy.sh/NTFY_TOPIC
	fi
}
detect_top_proccess
check_zombie
