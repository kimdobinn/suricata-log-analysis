#!/bin/bash

# Define paths
INPUT_LOG="/var/log/suricata/eve.json"
OUT_DIR="/var/log/suricata/alerts_by_severity"
OUT1="$OUT_DIR/severity_1_alerts.json"
OUT2="$OUT_DIR/severity_2_alerts.json"

# Create output directory if it doesn't exist
mkdir -p "$OUT_DIR"

# Extract and overwrite severity 1 alerts
jq 'select(.event_type == "alert" and .alert.severity == 1)' "$INPUT_LOG" > "$OUT1"

# Extract and overwrite severity 2 alerts
jq 'select(.event_type == "alert" and .alert.severity == 2)' "$INPUT_LOG" > "$OUT2"

echo "[$(date)] Severity 1 and 2 alert logs updated." >> /var/log/suricata/alerts_by_severity/cron_output.log