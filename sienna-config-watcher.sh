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
# Dependencies: cron
# =====================================================================

# INSTALL
# 1. change paths to relevant paths
# 2. configure crontab -e in root user
# 3. make sure permissions work in replaced XML config
# 4. put backup config in storage location and verify path

$PWD='/root/sienna'

# refer to the config vars
.  /root/sienna/config.sh

echo "This is the path to the config we are monitoring: $FULL_CONF_PATH"

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
conf_ok=$(check_file $FULL_CONF_PATH)
backup_ok=$(check_file $FULL_BACKUP_PATH)

if  [ $backup_ok -eq 1 ]; then
    echo "Backup is fine. Checking for running config".
    if  [ $conf_ok -eq 1 ]; then
        echo "Running onfig is fine. No action taken."
        # $(cp $FULL_CONF_PATH $FULL_BACKUP_PATH)
    elif [ $conf_ok -eq 0 ]; then
        echo "Running config broken. Restoring from backup".
        $(cp $FULL_BACKUP_PATH $FULL_CONF_PATH)
    else
        echo "Something went seriously wrong."
    fi
    
elif [ $backup_ok -eq 0 ]; then
    echo "Backup is missing, please provide external running conf to source dir:"
    echo $FULL_BACKUP_PATH
fi


