# ---------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ---------------------------------------------------------------------------
# Name.......: outputs.tf
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2020.10.12
# Revision...: 
# Purpose....: Output for the terraform module tvdlab compute.
# Notes......: -- 
# Reference..: --
# License....: Apache License Version 2.0, January 2004 as shown
#              at http://www.apache.org/licenses/
# ---------------------------------------------------------------------------

# display public IPs
output "host_id" {
  description = "OCID of the server instances."
  value = oci_core_instance.compute.*.id
}

output "host_public_ip" {
  description = "The public IP address of the server instances."
  value = oci_core_instance.compute.*.public_ip
}
# --- EOF -------------------------------------------------------------------