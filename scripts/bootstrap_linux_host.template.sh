#!/bin/bash
# ---------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ---------------------------------------------------------------------------
# Name.......: bootstrap_db_server.sh 
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2020.04.28
# Revision...: 
# Purpose....: Script to bootstrap the db server.
# Notes......: --
# Reference..: --
# License....: Licensed under the Universal Permissive License v 1.0 as 
#              shown at http://oss.oracle.com/licenses/upl.
# ---------------------------------------------------------------------------
# Modified...:
# see git revision history for more information on changes/updates
# ---------------------------------------------------------------------------
export SCRIPT_NAME="bootstrap_db_host.sh"
export LOG_BASE=${LOG_BASE:-"/var/log"}                     # Use script directory as default logbase
export ORACLE_USER="oracle"

LOGFILE="${LOG_BASE}/$(basename ${SCRIPT_NAME} .sh).log"
touch ${LOGFILE} 2>/dev/null
echo "INFO: Start the bootstrap process on db host $(hostname) at $(date)"      >>${LOGFILE} 2>&1

# add bootstrap stuff here...

echo "INFO: Finish the bootstrap process on db host $(hostname) at $(date)"     >>${LOGFILE} 2>&1
# --- EOF --------------------------------------------------------------------