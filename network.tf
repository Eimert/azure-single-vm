resource "azurerm_virtual_network" "network" {
    name = "vmNetwork"
    resource_group_name = "${azurerm_resource_group.pineapple.name}"
    address_space = ["10.0.0.0/16"]
    location = "West Europe"
}

resource "azurerm_subnet" "subnet" {
    name = "vmSubnet"
    resource_group_name = "${azurerm_resource_group.pineapple.name}"
    virtual_network_name = "${azurerm_virtual_network.network.name}"
    address_prefix = "10.0.2.0/24"
    # security group association with subnet is not working - now associated with the network interfaces
    #network_security_group_id = "${azurerm_network_security_group.secpol.id}"
}

resource "azurerm_public_ip" "publicip" {
    name = "vmPublicIP"
    location = "West Europe"
    resource_group_name = "${azurerm_resource_group.pineapple.name}"
    public_ip_address_allocation = "static"
    domain_name_label = "wellformed"

    tags {
        environment = "development"
    }
}

resource "azurerm_network_interface" "eth" {
    name = "eth"
    location = "West Europe"
    resource_group_name = "${azurerm_resource_group.pineapple.name}"
    #virtual_machine_id = "${azurerm_virtual_machine.puppetmaster.id}"
    #network_security_group_id = "${azurerm_network_security_group.secpol.id}"

    ip_configuration {
        name = "ipconfig"
        subnet_id = "${azurerm_subnet.subnet.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id = "${azurerm_public_ip.publicip.id}"
    }

    tags {
        environment = "development"
    }
}