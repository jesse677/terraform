locals {

  hardware = {
    cores    = 1
    memory   = 1024
    cpu_type = "x86-64-v2"
  }

  boot_disk_size = 15

  network_devices = [
    {
      bridge = "vmbr0"
    }
  ]
}
