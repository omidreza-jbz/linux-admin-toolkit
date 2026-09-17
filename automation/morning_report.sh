#!/bin/bash

get_uptime(){
	up_time=$(uptime -p)
}

get_disk(){
	disk_usage=$(df -h | grep sda3 | awk '{print $5}')
}
get_mem(){
	mem_usage=$(free | awk '/Mem:/ {printf "%.0f", ($3/$2)*100}')
}
get_failed_login(){
	failed_login_count=$(journalctl -u sshd --since "24 hours ago" | grep "Failed password" | wc -l)
}
send_report(){
	curl -d "Daily Report:
System uptime: $up_time
System Disk Usage: $disk_usage
System Mem Usage: $mem_usage
Ssh Failed Login Attempt: $failed_login_count" ntfy.sh/linux_ssh_gemini_project
}
get_uptime
get_disk
get_mem
get_failed_login
send_report
