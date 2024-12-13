# System_Monitoring_Script

This Bash script, (monitor_system.sh), monitors system performance and generates reports with real-time alerts. It tracks CPU usage, memory usage, disk space, and the top 5 CPU-consuming processes. Users can customize the monitoring interval (--interval) and output format (--format, options: text, JSON, CSV). Alerts are triggered if CPU usage exceeds 80%, memory usage exceeds 75%, or disk usage exceeds 90%. The script ensures robust error handling for invalid inputs and generates reports in the specified format for easy review.


Instructions to run the script:-

1.Save/Download the script as monitor_system.sh.

2.Make it executable: chmod +x monitor_system.sh.

3.Run the script with options: ./monitor_system.sh --interval 10 --format json.(change format as csv/json/txt as per requirement).

4.The output file will be generated in the specified format.
