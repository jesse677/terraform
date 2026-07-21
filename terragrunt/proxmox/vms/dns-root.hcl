# Shared configuration for the Technitium DNS resolver VMs (dns-01/02/03).
# Read by the dns-* leaf directories alongside vms-root.hcl; DNS-specific
# settings live here instead of vms-root.hcl so other VMs are unaffected.
locals {

  # Technitium is lightweight - small footprint per resolver
  hardware = {
    cores    = 1
    memory   = 1024
    cpu_type = "x86-64-v2"
  }

  boot_disk_size = 15

  # Management network only
  network_devices = [
    {
      bridge = "vmbr0"
    }
  ]
}
