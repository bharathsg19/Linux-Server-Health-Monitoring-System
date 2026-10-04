#!/bin/bash

LOG="$HOME/linux-health-monitor/logs/health_report.log"

echo "================================" >> "$LOG"
echo "Linux Server Health Report" >> "$LOG"
date >> "$LOG"

echo "----- Uptime -----" >> "$LOG"
uptime >> "$LOG"

echo "----- Memory Usage -----" >> "$LOG"
free -h >> "$LOG"

echo "----- Disk Usage -----" >> "$LOG"
df -h >> "$LOG"

echo "----- CPU Information -----" >> "$LOG"
top -bn1 | head -5 >> "$LOG"

echo "----- Failed Services -----" >> "$LOG"
systemctl --failed --no-legend >> "$LOG"

echo "----- Recent System Errors -----" >> "$LOG"
journalctl -p err -n 5 --no-pager >> "$LOG"

echo "Health report generated successfully!"

