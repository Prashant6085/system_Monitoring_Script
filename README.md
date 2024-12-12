# System_Monitoring_Script

This Bash script, (monitor_system.sh), monitors system performance and generates reports with real-time alerts. It tracks CPU usage, memory usage, disk space, and the top 5 CPU-consuming processes. Users can customize the monitoring interval (--interval) and output format (--format, options: text, JSON, CSV). Alerts are triggered if CPU usage exceeds 80%, memory usage exceeds 75%, or disk usage exceeds 90%. The script ensures robust error handling for invalid inputs and generates reports in the specified format for easy review.


This Bash script, monitor_system.sh, includes a --help feature to assist users in understanding its functionality and usage.

Run the script with help flag(./monitor_system.sh --help), the output will be as below:-

Usage: ./monitor_system.sh [--interval SECONDS] [--format text|json|csv] [--help]

Options:
  --interval SECONDS   Set the monitoring interval (default: 5 seconds).
  --format FORMAT      Set the output format (text/json/csv, default: text).
  --help               Show this help message.


Instructions to run the script:-

1.Save/Download the script as monitor_system.sh.

2.Make it executable: chmod +x monitor_system.sh.

3.Run the script with options: ./monitor_system.sh --interval 10 --format json.

4.The output file will be generated in the specified format.
