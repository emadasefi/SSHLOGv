#!/bin/bash

# Check journalctl availability
if ! command -v journalctl &> /dev/null; then
    echo "Error: journalctl not found! This script requires systemd."
    echo "Install systemd-journal or use alternative logging methods."
    exit 1
fi

# Get terminal width
TERM_WIDTH=$(tput cols)

# Dynamic column widths (responsive)
DATE_WIDTH=8
TIME_WIDTH=8
SESSION_WIDTH=10
USERNAME_WIDTH=10
WRONG_USER_WIDTH=10
PUBKEY_WIDTH=10
SYSTEM_WIDTH=15
SUCCESS_WIDTH=8
FAILED_WIDTH=8
PASSWD_WIDTH=8
USER_WIDTH=8
SRC_IP_WIDTH=15
DST_IP_WIDTH=15
PORT_WIDTH=5

# Calculate total width
TOTAL_WIDTH=$((DATE_WIDTH + TIME_WIDTH + SESSION_WIDTH + USERNAME_WIDTH + WRONG_USER_WIDTH + PUBKEY_WIDTH + SYSTEM_WIDTH + SUCCESS_WIDTH + FAILED_WIDTH + PASSWD_WIDTH + USER_WIDTH + SRC_IP_WIDTH + DST_IP_WIDTH + PORT_WIDTH))

# Check if terminal is wide enough
if ((TERM_WIDTH < TOTAL_WIDTH)); then
    echo "Warning: Terminal width (${TERM_WIDTH}) is narrower than table width (${TOTAL_WIDTH})"
    echo "Table may wrap. Consider widening your terminal."
fi

# Compact table formatting
format_log() {
    local log_line="$1"
    local timestamp=$(echo "$log_line" | awk '{print $1, $2, $3}')
    local message=$(echo "$log_line" | sed -E 's/^.*sshd\[.*\]: //')
    
    # Extract key details
    local date=$(echo "$timestamp" | awk '{print $1}')
    local time=$(echo "$timestamp" | awk '{print $3}')
    local session_type=$(echo "$message" | grep -oE 'session.*opened' | awk '{print $2}')
    local username=$(echo "$message" | grep -oE 'user.*from' | awk '{print $2}')
    local wrong_user=$(echo "$message" | grep -qE 'Failed.*user' && echo "Yes" || echo "No")
    local pubkey_type=$(echo "$message" | grep -oE 'publickey.*type' | awk '{print $3}')
    local system=$(echo "$message" | grep -oE 'from.*port' | awk '{print $2}')
    local success=$(echo "$message" | grep -qE 'Accepted' && echo "Yes" || echo "No")
    local failed=$(echo "$message" | grep -qE 'Failed' && echo "Yes" || echo "No")
    local failed_password=$(echo "$message" | grep -qE 'Failed.*password' && echo "Yes" || echo "No")
    local src_ip=$(echo "$message" | grep -oE 'from.*port' | awk '{print $2}')
    local dst_ip=$(echo "$message" | grep -oE 'from.*port' | awk '{print $2}')
    local port=$(echo "$message" | grep -oE 'port.*ssh2' | awk '{print $2}')
    
    # Truncate long values to prevent overflow
    system=$(echo "$system" | cut -c1-${SYSTEM_WIDTH})
    src_ip=$(echo "$src_ip" | cut -c1-${SRC_IP_WIDTH})
    dst_ip=$(echo "$dst_ip" | cut -c1-${DST_IP_WIDTH})
    
    printf "%-${DATE_WIDTH}s | %-${TIME_WIDTH}s | %-${SESSION_WIDTH}s | %-${USERNAME_WIDTH}s | %-${WRONG_USER_WIDTH}s | %-${PUBKEY_WIDTH}s | %-${SYSTEM_WIDTH}s | %-${SUCCESS_WIDTH}s | %-${FAILED_WIDTH}s | %-${PASSWD_WIDTH}s | %-${USER_WIDTH}s | %-${SRC_IP_WIDTH}s | %-${DST_IP_WIDTH}s | %-${PORT_WIDTH}s\n" \
        "$date" "$time" "$session_type" "$username" "$wrong_user" "$pubkey_type" "$system" "$success" "$failed" "$failed_password" "$wrong_user" "$src_ip" "$dst_ip" "$port"
}

display_header() {
    printf "%-${DATE_WIDTH}s | %-${TIME_WIDTH}s | %-${SESSION_WIDTH}s | %-${USERNAME_WIDTH}s | %-${WRONG_USER_WIDTH}s | %-${PUBKEY_WIDTH}s | %-${SYSTEM_WIDTH}s | %-${SUCCESS_WIDTH}s | %-${FAILED_WIDTH}s | %-${PASSWD_WIDTH}s | %-${USER_WIDTH}s | %-${SRC_IP_WIDTH}s | %-${DST_IP_WIDTH}s | %-${PORT_WIDTH}s\n" \
        "DATE" "TIME" "SESSION" "USERNAME" "WRONG_USER" "PUBKEY" "SYSTEM" "SUCCESS" "FAILED" "PASSWD" "USER" "SRC_IP" "DST_IP" "PORT"
    printf "%-${DATE_WIDTH}s | %-${TIME_WIDTH}s | %-${SESSION_WIDTH}s | %-${USERNAME_WIDTH}s | %-${WRONG_USER_WIDTH}s | %-${PUBKEY_WIDTH}s | %-${SYSTEM_WIDTH}s | %-${SUCCESS_WIDTH}s | %-${FAILED_WIDTH}s | %-${PASSWD_WIDTH}s | %-${USER_WIDTH}s | %-${SRC_IP_WIDTH}s | %-${DST_IP_WIDTH}s | %-${PORT_WIDTH}s\n" \
        $(printf "%-${DATE_WIDTH}s" "--------") \
        $(printf "%-${TIME_WIDTH}s" "--------") \
        $(printf "%-${SESSION_WIDTH}s" "----------") \
        $(printf "%-${USERNAME_WIDTH}s" "----------") \
        $(printf "%-${WRONG_USER_WIDTH}s" "----------") \
        $(printf "%-${PUBKEY_WIDTH}s" "----------") \
        $(printf "%-${SYSTEM_WIDTH}s" "---------------") \
        $(printf "%-${SUCCESS_WIDTH}s" "--------") \
        $(printf "%-${FAILED_WIDTH}s" "--------") \
        $(printf "%-${PASSWD_WIDTH}s" "--------") \
        $(printf "%-${USER_WIDTH}s" "--------") \
        $(printf "%-${SRC_IP_WIDTH}s" "---------------") \
        $(printf "%-${DST_IP_WIDTH}s" "---------------") \
        $(printf "%-${PORT_WIDTH}s" "-----")
}

# Main menu loop
while true; do
    clear
	echo ">>===========================================<<";
	echo "||  ____ ____  _   _ _     ___   ____        ||";
	echo "|| / ___/ ___|| | | | |   / _ \ / ___|_   __ ||";
	echo "|| \___ \___ \| |_| | |  | | | | |  _\ \ / / ||";
	echo "||  ___) |__) |  _  | |__| |_| | |_| |\ V /  ||";
	echo "|| |____/____/|_| |_|_____\___/ \____| \_/   ||";
	echo "||                                           ||";
	echo ">>============== SSH Log Viewer =============<<";
	echo ">>===========================================<<";
	echo ">>==== @emadasefi / emad.asefi@gmail.com ====<<";
	echo ">>===========================================<<";

    echo ""
    echo "1. => Live Stream"
    echo "2. => Last 10 Logs"
    echo "3. => Filter by User"
    echo "4. => Filter by Failed Sessions"
    echo "5. => Filter by Date"
    echo "6. => Exit"
    read -p "Choose: " choice
    
    case $choice in
        1)
            echo "Live Log Stream"
            echo "----------------"
            display_header
            sudo journalctl -u ssh -f --no-pager | while read -r line; do
                format_log "$line"
            done
            ;;
            
        2)
            echo "Last 10 Logs"
            echo "-------------"
            display_header
            sudo journalctl -u ssh -n 10 | while read -r line; do
                format_log "$line"
            done
            read -p "Save? (y/n): " save
            if [[ "$save" == "y" ]]; then
                read -p "Filename: " file
                sudo journalctl -u ssh -n 10 > "$file"
                echo "Saved to $file"
            fi
            read -p "Press Enter..."
            ;;
            
        3)
            echo "Filter by Successful User"
            echo "-------------------------"
            read -p "Enter username: " user_filter
            read -p "Show last X entries (default=10): " count
            count=${count:-10}
            display_header
            sudo journalctl -u ssh | grep -E "user $user_filter" | tail -n "$count" | while read -r line; do
                format_log "$line"
            done
            read -p "Save? (y/n): " save
            if [[ "$save" == "y" ]]; then
                read -p "Filename: " file
                sudo journalctl -u ssh | grep -E "user $user_filter" | tail -n "$count" > "$file"
                echo "Saved to $file"
            fi
            read -p "Press Enter..."
            ;;
            
        4)
            echo "Filter by Failed Sessions"
            echo "-------------------------"
            read -p "Show last X entries (default=10): " count
            count=${count:-10}
            display_header
            sudo journalctl -u ssh | grep -E 'Failed' | tail -n "$count" | while read -r line; do
                format_log "$line"
            done
            read -p "Save? (y/n): " save
            if [[ "$save" == "y" ]]; then
                read -p "Filename: " file
                sudo journalctl -u ssh | grep -E 'Failed' | tail -n "$count" > "$file"
                echo "Saved to $file"
            fi
            read -p "Press Enter..."
            ;;
            
        5)
            echo "Filter by Date"
            echo "--------------"
            read -p "Enter date (YYYY-MM-DD): " date_filter
            read -p "Show last X entries (default=10): " count
            count=${count:-10}
            display_header
            sudo journalctl -u ssh --since "$date_filter" --until "$(date -d "$date_filter +1 day" +%Y-%m-%d)" | tail -n "$count" | while read -r line; do
                format_log "$line"
            done
            read -p "Save? (y/n): " save
            if [[ "$save" == "y" ]]; then
                read -p "Filename: " file
                sudo journalctl -u ssh --since "$date_filter" --until "$(date -d "$date_filter +1 day" +%Y-%m-%d)" | tail -n "$count" > "$file"
                echo "Saved to $file"
            fi
            read -p "Press Enter..."
            ;;
            
        6)
            exit 0
            ;;
            
        *)
            echo "Invalid choice"
            read -p "Press Enter..."
            ;;
    esac
done
