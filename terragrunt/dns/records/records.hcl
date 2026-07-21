# All Technitium DNS records, keyed by a unique identifier. Add new records
# here - terragrunt.hcl in this directory turns every entry into a
# technitium_record resource, so this is the only file that needs to change.
# `zone` must match a zone name created in ../zones/zones.hcl.
locals {
  records = {
    steam-server = {
      zone       = "taylor.net"
      domain     = "steam-server.taylor.net"
      type       = "A"
      ttl        = 3600
      ip_address = "192.168.20.2"
    }
  }
}
