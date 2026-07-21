resource "technitium_record" "record" {
  for_each = var.records

  zone       = each.value.zone
  domain     = each.value.domain
  type       = each.value.type
  ttl        = each.value.ttl
  ip_address = each.value.ip_address
  cname      = each.value.cname
  priority   = each.value.priority
  weight     = each.value.weight
  port       = each.value.port
  target     = each.value.target
}
