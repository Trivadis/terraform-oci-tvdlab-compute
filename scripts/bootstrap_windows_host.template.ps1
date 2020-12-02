#ps1_sysnative
# ---------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ---------------------------------------------------------------------------
# Name.......: bootstrap_windows_host.template.ps1
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2020.04.22
# Revision...: 
# Purpose....: Script to bootstrap the ad server
# Notes......:  
# Reference..: --
# License....: Licensed under the Universal Permissive License v 1.0 as 
#              shown at http://oss.oracle.com/licenses/upl.
# ---------------------------------------------------------------------------
# Modified...:
# see git revision history for more information on changes/updates

# Set the Administrator Password and activate the Domain Admin Account
# net user Administrator ${default_password} /logonpasswordchg:no /active:yes
# --- EOF --------------------------------------------------------------------