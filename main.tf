# required vars (no default value:)
variable "subscription_id" {
  description   = "Azure subscription id"
}

variable "client_id" {
  description   = "Azure client id"
}

variable "client_secret" {
  description   = "Azure client secret"
}

variable "tenant_id" {
  description   = "Azure tenant id"
}


# Configure the Azure Resource Manager Provider
provider "azurerm" {
  subscription_id   = "${var.subscription_id}"
  client_id         = "${var.client_id}"
  client_secret     = "${var.client_secret}"
  tenant_id         = "${var.tenant_id}"
}


resource "azurerm_resource_group" "pineapple" {
    name            = "pineapple"
    location        = "West Europe"
}

resource "azurerm_virtual_machine" "wellformed" {
    name = "wellformed"
    location = "West Europe"
    resource_group_name = "${azurerm_resource_group.pineapple.name}"
    network_interface_ids = ["${azurerm_network_interface.eth.id}"]
    vm_size = "Basic_A1"

    storage_image_reference {
    publisher = "OpenLogic"
    offer = "CentOS"
    sku = "7.3"
    version = "latest"
    }

    storage_os_disk {
        name = "masterdisk"
        vhd_uri = "${azurerm_storage_account.coconut.primary_blob_endpoint}${azurerm_storage_container.stconta.name}/masterdisk.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "wellformed"
        admin_username = "testadmin"
        admin_password = "Alexandra.Phd"
    }

    os_profile_linux_config {
        # when password authentication is true, the admin user doesn't need to use sudo!
        disable_password_authentication = true
        # unable to copy public ssh key to /root = known issue in Terraform
        ssh_keys {
            # copies the public key for key-based authentication
            path = "/home/testadmin/.ssh/authorized_keys"
            key_data = "${file("keys/id_rsa.pub")}"
        }
    }
}
                            #################################
                            #                               #
                            #                               #
                            #                               #
                            #################################
