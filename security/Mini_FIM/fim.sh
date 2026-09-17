#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
RESET='\033[0m'

db_file="database.db"

input_command=$1

chosen_directory="${2:-/etc}"

if [[ "$input_command" == "--init" ]];then
>"$db_file"
	for i in "$chosen_directory"/*;do
		if [[ -f "$i" ]];then
			sha256sum "$i" 2>/dev/null >>"$db_file"
		fi
	done
elif [[ "$input_command" == "--check" ]]; then
	cat "$db_file" | while read old_hash file_path; do
		if [[ ! -f "$file_path" ]];then
			echo -e "${RED}[WARNING]A File Is Missing: $file_path${RESET}"
			continue
		fi
		new_hash=$(sha256sum "$file_path" | awk '{print $1}')
		if [[ $old_hash == $new_hash ]];then
			echo -e "${GREEN}[OK] everything is OK: $file_path${RESET}"
		else
			echo -e "${RED}CRITICAL: File $file_path has been modifided!${RESET}"
			curl -d "We're Fucked Boss! Modified: $file_path"ntfy.sh/YOUR_NTFY_URL_HERE
		fi
	done
	for current_file in "$chosen_directory"/*;do
                if [[ -f "$current_file" ]];then
                        if ! grep -q "$current_file" "$db_file"; then
				echo -e "${RED}[WARNING] Untracked/New File Detected: $current_file${RESET}"
			fi
                fi
        done
fi
