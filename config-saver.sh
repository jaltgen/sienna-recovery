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

# MODIFY HERE
VARS='/home/ubuntu/config-saver/config.sh'

# INSTALL
# 1. change paths to relevant paths
# 2. configure crontab -e in root user
# 3. make sure permissions work in replaced XML config
# 4. put backup config in storage location and verify path

# NO MODIFICATION NEEDED BEYOND THIS POINT

# refer to the config vars
. $VARS

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

function exit-checks(){
        $(log "The following backup will be used to restore NDIPE config: $1")
        $(cp $1 $FULL_CONF_PATH)
        $(chown $SIENNA_USER:$SIENNA_GROUP $FULL_CONF_PATH)
        # compare the two files and see if they are the same
        $(cmp --silent $1 $FULL_CONF_PATH  && log "Conf has been restored to: $FULL_CONF_PATH" || log "Config could not be restored.")
        exit 1
}

conf_ok=$(check_file $FULL_CONF_PATH)
pre_boot_ok=$(check_file $PRE_BACKUP_PATH) 
last_flush_ok=$(check_file $LAST_BACKUP_PATH) 
backup_ok=$(check_file $FULL_BACKUP_PATH)


if  [ $conf_ok -eq 1 ]; then
    # if the config file is fine, no action is taken and the script terminates
    $(log "Running config at $FULL_CONF_PATH is >0bytes. No restorting action required.")
    exit 1
elif [ $conf_ok -eq 0 ]; then
    # if the config file is not fine, we commence searching for backups
    $(log "NDIPE config seems broken (==0bytes or missing). Commencing checks of backups.")
    if  [ $pre_boot_ok -eq 1 ]; then
        # the pre-boot backup is the "latest" we have, thus given preference as it maintains user changes till the last shutdown
        $(exit-checks $PRE_BACKUP_PATH) 
    elif [ $last_flush_ok -eq 1 ]; then
        # if the pre-boot is broken (because maybe the problem exists in the OS @boot, we can still use the pre-shutdown one
        $(exit-checks $LAST_BACKUP_PATH) 
    elif [ $backup_ok -eq 1 ]; then
        # if even the pre shutdown one is broken, we can still refer to the user-supplied "golden backup" 
        $(exit-checks $FULL_BACKUP_PATH) 
    else    
        # if no backup was found at all, we have a serious issue
        $(log "No backup could be found that was >0bytes. Something went seriously wrong.")
    fi
else
    # if we couldn't even verify the initial config, something else entirely might be going on
    $(log "Something went seriously wrong.")
fi


