#!/bin/sh
# ./tests.sh -[rplb]
# -r : Running conf removed
# -p : Pre boot backup removed
# -l : Last flush backup removed
# -b : golden Backup removed

. /home/ubuntu/config-saver/config.sh
OPTIONS='rplb'

while getopts $OPTIONS opt; do
    case $opt in
        r)
            rm $FULL_CONF_PATH
            ;;
        p)
            rm $PRE_BACKUP_PATH
            ;;
        l)
            rm $LAST_BACKUP_PATH
            ;;
        b)
            rm $FULL_BACKUP_PATH
            ;;
    esac
done
