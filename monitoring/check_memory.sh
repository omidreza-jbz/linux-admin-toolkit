#!/bin/bash

read -p "Enter memory threshold percentage: " mem_usage

if [[ "$mem_usage" == "" ]]; then
	
	mem_usage=80
fi

memory_usage_percent(){
	local mem_c_usage=$(free | grep Mem | awk '{print int($3/$2 * 100)}')

	if [[ "$mem_c_usage" -ge "$mem_usage" ]]; then
		echo "[ALERT] Memory usage is HIGH: ${mem_c_usage}"
	else
		echo "[OK] Memory usage is NORMAL: ${mem_c_usage}"
	fi
}
memory_usage_percent
