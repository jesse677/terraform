variable "zones" {
  description = "DNS zones to create, keyed by a unique identifier"
  type = map(object({
    name = string
    type = string
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
