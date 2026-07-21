variable "records" {
  description = "DNS records to create, keyed by a unique identifier"
  type = map(object({
    zone       = string
    domain     = string
    type       = string
    ttl        = number
    ip_address = optional(string)
    cname      = optional(string)
    priority   = optional(number)
    weight     = optional(number)
    port       = optional(number)
    target     = optional(string)
  }))
}

variable "technitium_url" {
  description = "Technitium server API URL (e.g. https://dns-01.taylor.net/api)"
  type        = string
}

variable "technitium_token" {
  description = "Technitium API token"
  type        = string
  sensitive   = true
}
