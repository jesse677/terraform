variable "content_type" {
  description = "Content type for the Proxmox VE download file resource"
  type        = string
  default     = "import"
}

variable "datastore_id" {
  description = "Datastore ID to store the downloaded image"
  type        = string
  default     = "images"
}

variable "node_name" {
  description = "Proxmox VE node name to download the image to"
  type        = string
  default     = "pve-node-01"
}

variable "url" {
  description = "URL of the image to download"
  type        = string
  default     = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}

variable "file_name" {
  description = "File name for the downloaded image"
  type        = string
  default     = "jammy-server-cloudimg-amd64-jellyfish.qcow2"
}