# generate graph of dependencies: terraform graph ../infra-terraform/ | dot -Tpng > graph.png

resource "null_resource" "generic" {
    triggers {
        vm = "${azurerm_virtual_machine.wellformed.name}"
    }
    depends_on = ["azurerm_virtual_machine.wellformed"]
}

resource "null_resource" "wellformed" {
    triggers {
        vm = "${azurerm_virtual_machine.wellformed.name}"
    }
    depends_on = ["azurerm_virtual_machine.wellformed"]

    connection {
        type = "ssh"
        host = "${azurerm_public_ip.publicip.ip_address}"
        user = "testadmin"
        private_key = "${file("keys/id_rsa")}"
    }

    # copy ssh keys
    provisioner "file" {
        source = "keys/"
        destination = "/home/testadmin/.ssh/"
    }

    # copy all provisioner scripts to /tmp
    provisioner "file" {
        source = "scripts/"
        destination = "/tmp/"
    }

    # execute!
    # provisioner "remote-exec" {
    #     inline = [
    #         "sudo chmod +x /tmp/*.sh",
    #         "sudo /tmp/generic.sh",
    #         "sudo /tmp/wellformedinstall.sh"
    #     ]
    # }
}
