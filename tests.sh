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

OPTIONS='lrpfbs'

while getopts $OPTIONS opt; do
    case $opt in
        l)  
            echo "==================="
            echo "CURENT STATUS"
            echo "==================="
            echo "Running conf dir:"
            ls "-la" "$RUNNING_CONF_PATH"
            echo "==================="
            echo "Golden Conf:"
            cat "$FULL_BACKUP_PATH"
            ;;
        r)
            rm "$FULL_CONF_PATH"
            log "Removed running conf at $FULL_CONF_PATH."
            ;;
        p)
            rm "$PRE_BACKUP_PATH"
            log "Removed pre-boot conf at $PRE_BACKUP_PATH."
            ;;
        f)
            rm "$LAST_BACKUP_PATH"
            log "Removed last-flush conf at $LAST_BACKUP_PATH."
            ;;
        b)
            rm "$FULL_BACKUP_PATH"
            log "Removed golden backup conf at $FULL_BACKUP_PATH."
            ;;
        s)
            cp "$FULL_CONF_PATH" "$FULL_BACKUP_PATH"
            log "Copied existing running conf to backup path."
            ;;
    esac
done
