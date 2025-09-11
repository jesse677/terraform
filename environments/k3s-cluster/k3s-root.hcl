locals {
  # Infrastructure settings
  ssh_public_key_file  = "~/.ssh/id_rsa.pub"

  # Network configuration
  public_network       = "192.168.20.0/24"
  cluster_network      = "192.168.30.0/24"
  public_gateway       = "192.168.20.1"

  # VM defaults
  vm_cores             = 8
  vm_memory            = 16384
  vm_cpu_type          = "x86-64-v2"
  vm_username          = "ubuntu"
  vm_password          = "ubuntu"
  cloud_init_datastore = "jtdt01-images"

  # K3s cluster configuration
  k3s_token            = get_env("K3S_TOKEN", "defaultk3stoken123")
  k3s_server_ip        = "192.168.20.21"

  # Shared resources
  disk_template        = "jtdt01-images:import/jammy-server-cloudimg-amd64-jellyfish.qcow2"
  disk_datastore       = "local-lvm"
  disk_size            = 100

  # Network devices (single interface for all VMs)
  network_devices = [
    {
      bridge  = "vmbr0"
    }
  ]

  # Disk configuration (same for all VMs)
  disks = [
    {
      datastore_id = "local-lvm"
      file_id      = "jtdt01-images:import/jammy-server-cloudimg-amd64-jellyfish.qcow2"
      interface    = "scsi0"
      size         = 100
      file_format  = "raw"
    }
  ]

  # Base cloud-init packages for K3s nodes (includes storage tools for Ceph)
  base_packages = [
    "curl", "wget", "git", "htop", "nano", "ufw",
    "nfs-common", "open-iscsi", "lvm2", "cryptsetup",
    "qemu-guest-agent", "util-linux", "parted", "smartmontools"
  ]

  # Host entries for all nodes
  host_entries = [
    "echo '192.168.20.21 k3s-server-01' >> /etc/hosts",
    "echo '192.168.20.22 k3s-agent-01' >> /etc/hosts",
    "echo '192.168.20.23 k3s-agent-02' >> /etc/hosts"
  ]

  # Base runcmd (common to all nodes)
  base_runcmds = [
    "systemctl enable ssh",
    "systemctl start ssh",
    "# Configure UFW for Kubernetes networking",
    "ufw allow ssh",
    "ufw allow from 10.42.0.0/16 to any",
    "ufw allow from 10.43.0.0/16 to any", 
    "ufw allow from 192.168.20.0/24 to any",
    "ufw --force enable",
    "# Enable IP forwarding for container networking",
    "echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf",
    "echo 'net.bridge.bridge-nf-call-iptables=1' >> /etc/sysctl.conf",
    "echo 'net.bridge.bridge-nf-call-ip6tables=1' >> /etc/sysctl.conf",
    "sysctl -p",
    "systemctl enable qemu-guest-agent",
    "systemctl start qemu-guest-agent"
  ]

  # K3s server specific commands
  k3s_server_runcmds = [
    "# K3s server firewall rules",
    "ufw allow 6443/tcp",
    "ufw allow 8472/udp",
    "ufw allow 10250/tcp",
    "ufw allow 2379:2380/tcp"
  ]

  # K3s agent specific commands  
  k3s_agent_runcmds = [
    "# K3s agent firewall rules",
    "ufw allow 8472/udp",
    "ufw allow 10250/tcp"
  ]

  # Ceph preparation commands
  ceph_runcmds = [
    "modprobe rbd",
    "echo 'rbd' >> /etc/modules-load.d/rbd.conf",
    "# Ensure LVM tools are available for Rook discovery",
    "systemctl enable lvm2-monitor",
    "systemctl start lvm2-monitor",
    "# Create device symlinks if they don't exist",
    "udevadm control --reload-rules",
    "udevadm trigger"
  ]
}

remote_state {
  backend = "local"
  config = {
    path = "${get_terragrunt_dir()}/terraform.tfstate"
  }
}