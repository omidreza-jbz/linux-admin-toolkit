#!/bin/bash

is_active() {
	local service_name=$1
	local status=$(systemctl is-active "$service_name")

	if [[ "$status" == "active" ]]; then
		echo "[UP] Service $service_name is up"
		
	else

		echo "[DOWN] Service $service_name is down"
	fi
}

username=$(whoami)
sysname=$(hostname)
current_time=$(date)
echo "Current User: $username"
echo "Host Name:    $sysname"
echo "Date & Time:  $whattimeitis"

read -p "What service do you want me to check? " sname

is_active "$sname"
