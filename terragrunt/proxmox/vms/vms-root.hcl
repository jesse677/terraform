locals {

  # Infrastructure settings
  #ssh_public_key_file  = "~/.ssh/id_rsa.pub"
  ssh_public_key      = file("~/.ssh/id_rsa.pub")
  
  # Authentication defaults
  vm_username          = "ubuntu"
  vm_password          = get_env("VM_PASSWORD")
  
  cloud_init_datastore = "images"
  
  # Network configuration
  default_gateway       = "192.168.20.1"
  
  # Disk configuration defaults
  disk_template        = "images:import/jammy-server-cloudimg-amd64-jellyfish.qcow2"
  disk_datastore       = "local-lvm"
  disk_size            = 50

  # Network devices (single interface for all VMs)
  network_devices = [
    {
      bridge  = "vmbr0"
    }
  ]

  # Standard boot disk configuration using template
  boot_disk = {
    datastore_id = local.disk_datastore
    file_id      = local.disk_template
    interface    = "scsi0"
    size         = local.disk_size
    file_format  = "raw"
  }


  # Base cloud-init packages for VMs
  base_packages = [
    "curl", "wget", "git", "htop", "nano", "ufw",
    "qemu-guest-agent"
  ]

  # Base runcmd (common to all nodes)
  base_runcmds = [
    "systemctl enable ssh",
    "systemctl start ssh",
    "ufw force --disable",
    "sysctl -p",
    "systemctl enable qemu-guest-agent",
    "systemctl start qemu-guest-agent"
  ]
}