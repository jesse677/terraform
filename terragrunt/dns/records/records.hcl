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
    pi-led = {
      zone       = "taylor.net"
      domain     = "pi-led.taylor.net"
      type       = "A"
      ttl        = 3600
      ip_address = "192.168.88.249"
    }
    argocd = {
      zone       = "taylor.net"
      domain     = "argocd.taylor.net"
      type       = "A"
      ttl        = 3600
      ip_address = "192.168.30.240"
    }
    kibana = {
      zone       = "taylor.net"
      domain     = "kibana.taylor.net"
      type       = "A"
      ttl        = 3600
      ip_address = "192.168.30.240"
    }
    civic-radar = {
      zone   = "taylor.net"
      domain = "civic-radar.taylor.net"
      type   = "A"
      ttl    = 3600
      # Same Traefik LoadBalancer IP as argocd/kibana - one shared entrypoint,
      # host-header routing does the rest.
      ip_address = "192.168.30.240"
    }
    ollama-pc = {
      zone   = "taylor.net"
      domain = "ollama-pc.taylor.net"
      type   = "A"
      ttl    = 3600
      # BEST GUESS, PLEASE CONFIRM: this PC's LAN IP, queried via
      # `Get-NetIPAddress` from the Windows host. It's on the 192.168.88.0/24
      # segment (same as pi-led), a different VLAN than the k3s nodes
      # (192.168.30.0/24) - confirm cross-VLAN routing actually reaches it
      # before relying on this for the LLM-pass CronJob.
      ip_address = "192.168.88.6"
    }
  }
}
