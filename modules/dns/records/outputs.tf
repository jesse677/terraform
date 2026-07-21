output "records" {
  description = "Created DNS records, keyed by the same identifier as var.records"
  value = {
    for key, record in technitium_record.record : key => {
      zone   = record.zone
      domain = record.domain
      type   = record.type
    }
  }
}
