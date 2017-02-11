resource "azurerm_storage_account" "coconut" {
    # 29-06-16: it took terraform v0.72-rc2 and azure ~18.30 min. to create this storage account.
    name = "coconutstorage"
    resource_group_name = "${azurerm_resource_group.pineapple.name}"
    
    location = "West Europe"
    account_type = "Standard_LRS"

    tags {
        environment = "development"
    }
}

resource "azurerm_storage_container" "stconta" {
    name = "os-container"
    resource_group_name = "${azurerm_resource_group.pineapple.name}"
    storage_account_name = "${azurerm_storage_account.coconut.name}"
    container_access_type = "private" # or container
    depends_on = ["azurerm_storage_account.coconut"]
}