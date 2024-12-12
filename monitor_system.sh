#!/bin/bash

# Default configurations
INTERVAL=5
OUTPUT_FORMAT="text"
OUTPUT_FILE="system_report"

# Function to display help
show_help() {
    echo "Usage: $0 [--interval SECONDS] [--format text|json|csv] [--help]"
    echo ""
    echo "Options:"
    echo "  --interval SECONDS   Set the monitoring interval (default: 5 seconds)."
    echo "  --format FORMAT      Set the output format (text/json/csv, default: text)."
    echo "  --help               Show this help message."
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --interval)
            INTERVAL=$2
            shift 2
            ;;
        --format)
            OUTPUT_FORMAT=$2
            shift 2
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo "Invalid argument: $1"
            show_help
            exit 1
            ;;
    esac
done

# Validate interval
if ! [[ "$INTERVAL" =~ ^[0-9]+$ ]] || [[ "$INTERVAL" -le 0 ]]; then
    echo "Error: Interval must be a positive integer."
    exit 1
fi

# Collect system information
collect_system_info() {
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}')
    MEMORY_USAGE=$(free -m | awk 'NR==2{printf "Total: %s MB, Used: %s MB, Free: %s MB", $2, $3, $4}')
    DISK_USAGE=$(df -h | awk 'NR>1{printf "%s: Total=%s, Used=%s, Avail=%s\n", $6, $2, $3, $4}')
    TOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n +2)
}

# Check for alerts
check_alerts() {
    CPU_ALERT=$(echo $CPU_USAGE | awk '{if ($1+0 > 80) print "YES"; else print "NO"}')
    MEM_ALERT=$(free -m | awk 'NR==2{if ($3/$2*100 > 75) print "YES"; else print "NO"}')
    DISK_ALERT=$(df -h | awk 'NR>1{if ($5+0 > 90) print $6}')
}

# Generate report
generate_report() {
    echo "System Report:" > "$OUTPUT_FILE.$OUTPUT_FORMAT"
    echo "---------------------" >> "$OUTPUT_FILE.$OUTPUT_FORMAT"
    echo "CPU Usage: $CPU_USAGE" >> "$OUTPUT_FILE.$OUTPUT_FORMAT"
    echo "Memory Usage: $MEMORY_USAGE" >> "$OUTPUT_FILE.$OUTPUT_FORMAT"
    echo "Disk Usage:" >> "$OUTPUT_FILE.$OUTPUT_FORMAT"
    echo "$DISK_USAGE" >> "$OUTPUT_FILE.$OUTPUT_FORMAT"
    echo "Top 5 CPU-consuming processes:" >> "$OUTPUT_FILE.$OUTPUT_FORMAT"
    echo "$TOP_PROCESSES" >> "$OUTPUT_FILE.$OUTPUT_FORMAT"

    if [[ "$CPU_ALERT" == "YES" ]]; then
        echo "WARNING: CPU usage exceeded 80%!" >> "$OUTPUT_FILE.$OUTPUT_FORMAT"
    fi
    if [[ "$MEM_ALERT" == "YES" ]]; then
        echo "WARNING: Memory usage exceeded 75%!" >> "$OUTPUT_FILE.$OUTPUT_FORMAT"
    fi
    if [[ "$DISK_ALERT" != "" ]]; then
        echo "WARNING: Disk space usage exceeded 90% on: $DISK_ALERT" >> "$OUTPUT_FILE.$OUTPUT_FORMAT"
    fi
}

# Handle JSON and CSV output
handle_format_conversion() {
    if [[ "$OUTPUT_FORMAT" == "json" ]]; then
        # Convert to JSON
        echo "{\"cpu_usage\":\"$CPU_USAGE\",\"memory_usage\":\"$MEMORY_USAGE\",\"disk_usage\":\"$(echo $DISK_USAGE | tr '\n' ',')\",\"top_processes\":\"$(echo $TOP_PROCESSES | tr '\n' ',')\"}" > "$OUTPUT_FILE.json"
    elif [[ "$OUTPUT_FORMAT" == "csv" ]]; then
        # Convert to CSV
        echo "CPU Usage,Memory Usage,Disk Usage,Top Processes" > "$OUTPUT_FILE.csv"
        echo "$CPU_USAGE,$MEMORY_USAGE,\"$(echo $DISK_USAGE | tr '\n' ';')\",\"$(echo $TOP_PROCESSES | tr '\n' ';')\"" >> "$OUTPUT_FILE.csv"
    fi
}

# Main loop
while true; do
    collect_system_info
    check_alerts
    generate_report
    handle_format_conversion
    sleep "$INTERVAL"
done
