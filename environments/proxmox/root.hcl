locals {
  # Infrastructure settings
  ssh_public_key_file  = "~/.ssh/id_rsa.pub"

  # Network configuration
  public_network       = "192.168.20.0/24"
  cluster_network      = "192.168.30.0/24"
  public_gateway       = "192.168.20.1"

  # VM defaults
  vm_cores             = 4
  vm_memory            = 8192
  vm_cpu_type          = "x86-64-v2"
  vm_username          = "ubuntu"
  vm_password          = "ubuntu"
  cloud_init_datastore = "jtdt01-images"

  # Shared resources
  disk_template        = "jtdt01-images:import/jammy-server-cloudimg-amd64-jellyfish.qcow2"
  disk_datastore       = "local-lvm"
  disk_size            = 50

  # Network devices (generic for all VMs)
  network_devices = [
    {
      bridge  = "vmbr0"
    }
  ]

  # Disk configuration (generic for all VMs)
  disks = [
    {
      datastore_id = "local-lvm"
      file_id      = "jtdt01-images:import/jammy-server-cloudimg-amd64-jellyfish.qcow2"
      interface    = "scsi0"
      size         = 50
      file_format  = "raw"
    }
  ]

  # Base cloud-init packages (minimal set for generic VMs)
  base_packages = [
    "curl", "wget", "git", "htop", "nano", "ufw",
    "qemu-guest-agent"
  ]

  # Base runcmd (common to all VMs)
  base_runcmds = [
    "systemctl enable ssh",
    "systemctl start ssh",
    "ufw allow ssh",
    "ufw --force enable",
    "systemctl enable qemu-guest-agent",
    "systemctl start qemu-guest-agent"
  ]
}

remote_state {
  backend = "local"
  config = {
    path = "${get_terragrunt_dir()}/terraform.tfstate"
  }
}
