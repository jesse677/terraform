output "zones" {
  description = "Created DNS zones, keyed by the same identifier as var.zones"
  value = {
    for key, zone in technitium_zone.zone : key => {
      name = zone.name
      type = zone.type
    }
  }
}
