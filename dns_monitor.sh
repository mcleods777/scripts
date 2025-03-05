#!/bin/bash

LOG_FILE="/var/log/dns_monitor.log"
DOMAIN="ala-tuxlab-cn-insecure.wrs.com"

# Mark the start time
echo "$(date "+%Y-%m-%d %H:%M:%S") - DNS resolution monitoring started for $DOMAIN" >> "$LOG_FILE"

# Set end time to 24 hours from now
END_TIME=$(date -d "24 hours" +%s)

while true; do
  # Check if we've reached the time limit
  CURRENT_TIME=$(date +%s)
  if [ $CURRENT_TIME -ge $END_TIME ]; then
    echo "$(date "+%Y-%m-%d %H:%M:%S") - Monitoring completed after 24 hours" >> "$LOG_FILE"
    exit 0
  fi

  TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
  
  # Set a timeout (5 seconds)
  RESULT=$(dig +tries=1 +time=5 "$DOMAIN")
  
  # Check if resolution was successful
  if echo "$RESULT" | grep -q "ANSWER SECTION"; then
    # Extract query time for successful resolution
    QUERY_TIME=$(echo "$RESULT" | grep "Query time" | awk '{print $4}')
    echo "$TIMESTAMP - $DOMAIN - SUCCESS - Query time: $QUERY_TIME ms" >> "$LOG_FILE"
  else
    # Check if it was a timeout or other failure
    if echo "$RESULT" | grep -q "connection timed out"; then
      echo "$TIMESTAMP - $DOMAIN - TIMEOUT - DNS query timed out after 5 seconds" >> "$LOG_FILE"
    else
      # Other failure
      STATUS=$(echo "$RESULT" | grep -E "status:|ANSWER:" | head -1)
      echo "$TIMESTAMP - $DOMAIN - FAILED - $STATUS" >> "$LOG_FILE"
    fi
  fi
  
  # Sleep for 5 minutes
  sleep 300
done
