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

# INSTALL
# 1. change paths to relevant paths
# 2. configure crontab -e in root user
# 3. make sure permissions work in replaced XML config
# 4. put backup config in storage location and verify path

# refer to the config vars
.  /root/sienna/config.sh

function log(){
    $(logger "SIENNA-CONF: $1")
}
$(log "### COMMENCING CHECK PROCEDURE FOR 0byte ERROR###")
$(log "Monitored config file: $FULL_CONF_PATH")

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
    $(log "Backup exists in: $FULL_BACKUP_PATH")
    if  [ $conf_ok -eq 1 ]; then
        $(log "Running config at $FULL_CONF_PATH is >0bytes. No restorting action required.")
        # $(cp $FULL_CONF_PATH $FULL_BACKUP_PATH)
    elif [ $conf_ok -eq 0 ]; then
        $(log "Running config at $FULL_CONF_PATH is either ==0bytes or file does not exist. Restoring from backup at $FULL_BACKUP_PATH.")
        $(cp $FULL_BACKUP_PATH $FULL_CONF_PATH)
        $(chown $SIENNA_USER:$SIENNA_GROUP $FULL_CONF_PATH)
        # compare the two files and see if they are the same
        $(cmp --silent $FULL_CONF_PATH $FULL_BACKUP_PATH  && log "Conf has been restored to: $FULL_CONF_PATH" || log "Config could not be restored.")
    else    
        $(log "Something went seriously wrong.")
    fi
    
elif [ $backup_ok -eq 0 ]; then
    $(log "Backup is missing, please provide external running conf to source dir: $FULL_BACKUP_PATH")
fi


