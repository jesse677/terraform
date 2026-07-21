resource "technitium_zone" "zone" {
  for_each = var.zones

  name = each.value.name
  type = each.value.type
}
