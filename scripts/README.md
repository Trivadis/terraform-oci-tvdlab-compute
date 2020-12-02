# Scripts

This directory contains scripts used by *cloud-init* to setup and bootstrap the bastion host. Template files are adapted at runtime by Terraform `templatefile`. Variables are replaced accordingly.

- [bootstrap_linux_host.template.sh](bootstrap_linux_host.template.sh) Script respectively template to setup and initialize linux based hosts.
- [bootstrap_windows_host.template.ps1](bootstrap_windows_host.template.ps1) Script respectively template to setup and initialize windows based hosts.
