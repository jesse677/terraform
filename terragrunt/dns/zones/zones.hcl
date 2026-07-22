# All Technitium DNS zones, keyed by a unique identifier. Add new zones here -
# terragrunt.hcl in this directory turns every entry into a technitium_zone
# resource, so this is the only file that needs to change.
locals {
  zones = {
    #example = {
    #  name = "taylor.net"
    #  type = "Primary"
    #}
  }
}
