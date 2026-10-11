# Linux Server Health Monitoring System

A beginner-friendly Linux administration project that uses a Bash script to collect basic server health information and append it to a log file.

## Project Overview

This project monitors a Linux system's:

- System uptime
- Memory usage
- Disk usage
- CPU information
- Failed systemd services
- Recent system errors

The script writes a timestamped report to a log file. It can also be scheduled with `cron` to run automatically.

## Prerequisites

- Ubuntu Linux (physical machine, VM, or compatible environment)
- A user account with `sudo` access
- Bash shell
- `systemd` and `journalctl` (available on typical Ubuntu installations)

## Project Structure

```text
linux-health-monitor/
├── health_check.sh
└── logs/
    └── health_report.log
```

## 1. Install the Required Package

Update package information and install `sysstat`:

```bash
sudo apt update
sudo apt install -y sysstat
```

> The script below uses standard Ubuntu utilities. `sysstat` is included as a useful Linux monitoring package for future extensions.

## 2. Create the Project Directory

```bash
mkdir -p ~/linux-health-monitor/logs
cd ~/linux-health-monitor
```

## 3. Create the Bash Script

Create the file:

```bash
nano health_check.sh
```

Paste the following:

```bash
#!/bin/bash

set -u

PROJECT_DIR="$HOME/linux-health-monitor"
LOG="$PROJECT_DIR/logs/health_report.log"

mkdir -p "$(dirname "$LOG")"

{
    echo "========================================"
    echo "Linux Server Health Report"
    date
    echo

    echo "----- Uptime -----"
    uptime
    echo

    echo "----- Memory Usage -----"
    free -h
    echo

    echo "----- Disk Usage -----"
    df -h
    echo

    echo "----- CPU Information -----"
    top -bn1 | head -5
    echo

    echo "----- Failed Services -----"
    systemctl --failed --no-legend
    echo

    echo "----- Recent System Errors -----"
    journalctl -p err -n 5 --no-pager
    echo
} >> "$LOG"

echo "Health report generated: $LOG"
```

Save and exit the editor.

## 4. Make the Script Executable

```bash
chmod +x health_check.sh
```

## 5. Run the Health Check

```bash
./health_check.sh
```

View the generated report:

```bash
cat logs/health_report.log
```

To watch new report entries as they are appended:

```bash
tail -f logs/health_report.log
```

Press `Ctrl+C` to stop watching.

## 6. Schedule Automatic Execution with Cron

Find your home directory:

```bash
echo "$HOME"
```

Open your user crontab:

```bash
crontab -e
```

Add a line like the following, replacing `/home/yourusername` with your actual home directory:

```cron
0 9 * * * /home/yourusername/linux-health-monitor/health_check.sh
```

This runs the script every day at 9:00 AM, according to the machine's configured time zone.

Check the saved cron entries:

```bash
crontab -l
```

## 7. Example Use Cases

- Review disk capacity before it becomes critically low.
- Check whether systemd services are failing.
- Keep a simple history of server health snapshots.
- Practice Linux command-line operations and Bash scripting.
- Build a foundation for threshold alerts and monitoring automation.

## Troubleshooting

### Permission denied

```bash
chmod +x health_check.sh
```

### Log file is missing

Run the script from the project directory or use:

```bash
ls -l ~/linux-health-monitor/logs/
```

### `journalctl` shows limited or no logs

Some systems restrict access to system journal entries. Try running the script with appropriate privileges only if required by your environment, and avoid making the report file root-owned unintentionally.

### Cron does not run

- Confirm the entry with `crontab -l`.
- Use the full absolute path to the script.
- Confirm the script is executable.
- Check the system's cron service status:

```bash
systemctl status cron
```

## Learning Outcomes

By completing this project, you practice:

- Linux directory and file management
- Bash scripting
- Process and resource inspection
- Service and log troubleshooting
- File permissions
- Scheduling jobs with cron

## Future Improvements

- Add configurable CPU, memory, and disk thresholds.
- Print `WARNING` messages when a threshold is exceeded.
- Rotate old reports to prevent unbounded log growth.
- Send notifications through an approved email or monitoring service.
- Add command-line options for a one-time check or scheduled report.

## License

This project is provided for learning and personal portfolio use.
