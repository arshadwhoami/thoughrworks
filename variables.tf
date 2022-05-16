variable "azure_subscription_id" {
  type = string
  description = "Azure Subscription ID"
}
variable "azure_client_id" {
  type = string
  description = "Azure Client ID"
}
variable "azure_client_secret" {
  type = string
  description = "Azure Client Secret"
}
variable "azure_tenant_id" {
  type = string
  description = "Azure Tenant ID"
}
variable "network-vnet-cidr" {
  type = string
  description = "The CIDR of the network VNET"
}
variable "network-subnet-cidr" {
  type = string
  description = "The CIDR for the network subnet"
}
variable "location" {
  type = string
  description = "location"
}
variable "linux_vm_image_publisher" {
  type        = string
  description = "Virtual machine source image publisher"
  default     = "RedHat"
}
variable "linux_vm_image_offer" {
  type        = string
  description = "Virtual machine source image offer"
  default     = "RHEL"
}
variable "rhel_7_8_sku" {
  type        = string
  description = "SKU for RHEL 7.8"
  default     = "7.8"
}
variable "rhel_7_8_gen2_sku" {
  type        = string
  description = "SKU for RHEL 7.8 Gen2"
  default     = "78-gen2"
}
variable "rhel_7_9_sku" {
  type        = string
  description = "SKU for RHEL 7.9"
  default     = "7_9"
}
variable "rhel_7_9_gen2_sku" {
  type        = string
  description = "SKU for RHEL 7.9 Gen2"
  default     = "79-gen2"
}
variable "rhel_8_4_sku" {
  type        = string
  description = "SKU for RHEL 8.4"
  default     = "8_4"
}
variable "rhel_8_4_gen2_sku" {
  type        = string
  description = "SKU for RHEL 8.4 Gen2"
  default     = "84-gen2"
}
variable "rhel_8_5_sku" {
  type        = string
  description = "SKU for RHEL 8.5"
  default     = "8_5"
}
variable "rhel_8_5_gen2_sku" {
  type        = string
  description = "SKU for RHEL 8.5 Gen2"
  default     = "85-gen2"
}
variable "linux_vm_size" {
  type        = string
  description = "size"
  
}
variable "linux_admin_username" {
  type        = string
  description = "username"
  
}
