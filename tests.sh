#!/bin/sh
# ./tests.sh -[rplb]
# -r : Running conf removed
# -p : Pre boot backup removed
# -l : Last flush backup removed
# -b : golden Backup removed


SCRIPTLOCATION="/home/ubuntu/config-saver"
# shellcheck source=/home/ubuntu/config-saver/lib.sh
# shellcheck source=/home/ubuntu/config-saver/config.sh
. "$SCRIPTLOCATION/config.sh"
. "$SCRIPTLOCATION/lib.sh"
ID="SIENNA-TESTS"

OPTIONS='srplb'

while getopts $OPTIONS opt; do
    case $opt in
        s)  
            ls "$RUNNING_CONF_PATH"
            ;;
        r)
            rm "$FULL_CONF_PATH"
            log "Removed running conf at $FULL_CONF_PATH."
            ;;
        p)
            rm "$PRE_BACKUP_PATH"
            log "Removed pre-boot conf at $PRE_BACKUP_PATH."
            ;;
        l)
            rm "$LAST_BACKUP_PATH"
            log "Removed last-flush conf at $LAST_BACKUP_PATH."
            ;;
        b)
            rm "$FULL_BACKUP_PATH"
            log "Removed golden backup conf at $LAST_BACKUP_PATH."
            ;;
    esac
done
