# DNS Resolution Monitor

A simple tool to monitor DNS resolution times and detect failures for specific domains.

## Overview

This script checks DNS resolution for a configured domain at regular intervals and logs the results. It's designed to help identify DNS-related issues, especially those that occur intermittently or during off-hours.

## Features

- Monitors resolution time for a specified domain
- Detects successful resolutions, timeouts, and failures
- Logs results with timestamps for later analysis
- Automatically terminates after 24 hours

## Usage

1. Make the script executable:
   ```
   chmod +x dns_monitor.sh
   ```

2. Run the script in the background:
   ```
   nohup ./dns_monitor.sh &
   ```

3. Check the logs after the monitoring period:
   ```
   cat /var/log/dns_monitor.log
   ```

## Configuration

Edit the script to modify:
- `DOMAIN`: The domain to monitor
- `LOG_FILE`: Where to store the results
- Sleep duration: Change `sleep 300` to adjust the interval (in seconds)
- Duration: Change `24 hours` to adjust the total monitoring period

## Log Format

The log file contains entries in this format:
```
TIMESTAMP - DOMAIN - STATUS - DETAILS
```

Where:
- `STATUS` is one of: SUCCESS, TIMEOUT, FAILED
- `DETAILS` includes query time for successful resolutions or error information for failures

## Requirements

- Bash shell
- `dig` command (part of the `bind-utils` or `dnsutils` package)

## Analyzing Results

After the monitoring period, look for:
- Periods with consistently high resolution times
- Patterns of failures or timeouts
- Correlation between DNS issues and specific times of day
- Sudden spikes in resolution time

## Troubleshooting

If the script isn't working as expected:
- Ensure the domain is correctly specified
- Verify that `dig` is installed
- Check that the log location is writable
- Make sure the script has execution permissions

## License

MIT License
