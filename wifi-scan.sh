#!/bin/bash
# Script to run automated Wi-Fi scans with timestamps on GOST device

echo "Starting Wi-Fi scan test (press Ctrl+C to stop)..."
START_TIME=$(date +%s)
while true; do
    CURRENT_TIME=$(date)
    ELAPSED_SECONDS=$(( $(date +%s) - START_TIME ))
    ELAPSED_MINUTES=$(( ELAPSED_SECONDS / 60 ))
    ELAPSED_REMAINDER=$(( ELAPSED_SECONDS % 60 ))
    echo "=== Scan at $CURRENT_TIME (Elapsed: ${ELAPSED_MINUTES}m ${ELAPSED_REMAINDER}s) ==="
    nmcli device wifi list --rescan yes
    echo "==="
    sleep 60
done