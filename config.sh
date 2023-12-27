#!/bin/bash
# =====================================================================
# Title: Sienna Config Watcher - Configuration File
# Author: Jannik Altgen
# Date: January 1, 2024
# Purpose:  Configuration variables for the Sienna config watcher. 
# Usage: Set vars below. They will be sourced into the main script.
# Dependencies: n/a
# =====================================================================

# absolute path to the sienna confix XML file
FULL_CONF_PATH="/root/sienna/demo/config.xml"

# absolute path to the "golden" backup config file, that will be used if the running conf above is broken.
FULL_BACKUP_PATH="/root/sienna/demo/backup/config.bak.xml"

# user and group names of the user that runs the Sienna NDIPE. Most likely "ubuntu" and "ubuntu".
SIENNA_USER="ubuntu"
SIENNA_GROUP="ubuntu"

