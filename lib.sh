#!/bin/bash
# =====================================================================
# Title: Sienna Config Watcher
# Author: Jannik Altgen
# Date: January 1, 2024
# Purpose:  This is the sienna-scripts config watcher. 
# It checks, if the Sienna Engine config file is over 0 bytes in size. 
# If the file should get broken (signifiend by being 0 bytes) it will be restored. 
# To this end, a backup will be created every time the config is fine. 
# This script can then be called from cron every X minutes, to ensure there is a frequent file to backup.
# Usage: backup.sh
# Dependencies: cron, logger, awk, ls, cp
# =====================================================================


function log(){
    logger "$ID: $1"
}

function check_file(){
    if [ -s $1 ]; then
        # echo "File $1 exists."
        file_size=$(ls -l $1 | awk '{print $5}')
        if [ $file_size -gt 0 ]; then
            # echo "File size of $1 is greater than 0 bytes."
            echo 1
        else
            echo 0
        fi
    else
        echo 0
    fi
}