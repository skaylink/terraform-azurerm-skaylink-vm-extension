# A Terraform module to create a subset of cloud components
# Copyright (C) 2022 Skaylink GmbH

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# For questions and contributions please contact info@iq3cloud.com

variable "vm_name" {
  description = "Name of the VM to encrypt"
}

variable "vm_os_type" {
  description = "Type of OS. Allowed values are Windows and Linux. Defaults to Linux"
  default     = "linux"
}

variable "resource_group_name" {
  description = "Default resource group name that the network will be created in"
}

variable "key_vault_name" {
  description = "Name of the keyVault"
}

variable "key_vault_secret_name" {
  description = "Name of the keyVault"
}

variable "encryption_key_url" {
  description = "URL to encrypt Key"
}

variable "encryption_algorithm" {
  description = "Algorithm for encryption"
  default     = "RSA-OAEP"
}

variable "volume_type" {
  default = "All"
}

variable "workspace_id" {
  description = "Workspace ID for deployment of OMS agent"
}

variable "workspace_key" {
  description = "Workspace key for deployment of OMS agent"
}