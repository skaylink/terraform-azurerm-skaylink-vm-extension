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

## DISK encryption 
resource "azurerm_virtual_machine_extension" "diskextension" {
  count                = lower(var.vm_os_type) == "windows" ? 1 : 0
  name                 = "DiskEncryptionWIndows"
  virtual_machine_id   = data.azurerm_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.Security"
  type                 = "AzureDiskEncryption"
  type_handler_version = "1.1"
  settings             = <<SETTINGS
    {
        "AADClientID" : "${data.azurerm_client_config.current.client_id}",
        "EncryptionOperation": "EnableEncryption",
        "KeyVaultURL": "${data.azurerm_key_vault.keyvault.vault_uri}",
        "KeyVaultResourceId": "${data.azurerm_key_vault.keyvault.id}",					
        "KeyEncryptionKeyURL": "${var.encryption_key_url}",
        "KekVaultResourceId": "${data.azurerm_key_vault.keyvault.id}",					
        "KeyEncryptionAlgorithm": "${var.encryption_algorithm}",
        "VolumeType": "${var.volume_type}"
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "AADClientSecret" : "${data.azurerm_key_vault_secret.secret_disk_encryption.value}"
    }
PROTECTED_SETTINGS

}

resource "azurerm_virtual_machine_extension" "diskextensionlinux" {
  count                = lower(var.vm_os_type) == "linux" ? 1 : 0
  name                 = "DiskEncryptionLinux"
  virtual_machine_id   = data.azurerm_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.Security"
  type                 = "AzureDiskEncryptionForLinux"
  type_handler_version = "1.1"

  settings = <<SETTINGS
    {
        "AADClientID" : "${data.azurerm_client_config.current.client_id}",
        "EncryptionOperation": "EnableEncryption",
        "KeyVaultURL": "${data.azurerm_key_vault.keyvault.vault_uri}",
        "KeyVaultResourceId": "${data.azurerm_key_vault.keyvault.id}",					
        "KeyEncryptionKeyURL": "${var.encryption_key_url}",
        "KekVaultResourceId": "${data.azurerm_key_vault.keyvault.id}",					
        "KeyEncryptionAlgorithm": "${var.encryption_algorithm}",
        "VolumeType": "${var.volume_type}",
        "SkipVmBackup" : true
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "AADClientSecret" : "${data.azurerm_key_vault_secret.secret_disk_encryption.value}"
    }
PROTECTED_SETTINGS

}

### OMS Agent
resource "azurerm_virtual_machine_extension" "monitoringWindows" {
  count                = lower(var.vm_os_type) == "windows" ? 1 : 0
  name                 = "monitoringagent"
  virtual_machine_id   = data.azurerm_virtual_machine.vm.id
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "MicrosoftMonitoringAgent"
  type_handler_version = "1.0"

  settings = <<SETTINGS
        {
          "workspaceId": "${var.workspace_id}"
        }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
        {
          "workspaceKey": "${var.workspace_key}"
        }
PROTECTED_SETTINGS
}

resource "azurerm_virtual_machine_extension" "monitoringLinux" {
  count                = lower(var.vm_os_type) == "linux" ? 1 : 0
  name                 = "OmsAgentForLinux"
  virtual_machine_id   = data.azurerm_virtual_machine.vm.id
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "OmsAgentForLinux"
  type_handler_version = "1.8"

  settings = <<SETTINGS
    {
        "workspaceId": "${var.workspace_id}"
    }
SETTINGS

  protected_settings = <<PROTECTEDSETTINGS
    {
        "workspaceKey": "${var.workspace_key}"
    }
PROTECTEDSETTINGS
}

resource "azurerm_virtual_machine_extension" "antimalware" {
  count                = lower(var.vm_os_type) == "windows" ? 1 : 0
  name                 = "AntiMalware"
  virtual_machine_id   = data.azurerm_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.Security"
  type                 = "IaaSAntimalware"
  type_handler_version = "1.5"

  settings = <<SETTINGS
  {
    "AntimalwareEnabled": true,
    "RealtimeProtectionEnabled": "true",
    "ScheduledScanSettings": {
      "isEnabled": "true",
      "day": "7",
      "time": "120",
      "scanType": "Quick"
    },
    "Exclusions": {
        "Extensions": "",
        "Paths": "",
        "Processes": ""
    }
  }
  SETTINGS

}