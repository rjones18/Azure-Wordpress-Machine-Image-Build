source "azure-arm" "example" {
  use_azure_cli_auth = true
  managed_image_resource_group_name = "ami-group"
  managed_image_name                = "test-image-${formatdate("YYYYMMDDhhmmss", timestamp())}"

  os_type         = "Linux"
  image_publisher = "Canonical"
  image_offer     = "UbuntuServer"
  image_sku       = "18.04-LTS"

  azure_tags = {
    dept = "Engineering"
    task = "Image deployment"
  }

  location = "Central US"
  vm_size  = "Standard_DS2_v2"
}


build {
  sources = ["source.azure-arm.example"]

  provisioner "shell" {
    script = "./script.sh"
  }

  provisioner "shell" {
  inline = [
    "sudo chown -R $USER:$USER /var/www/wordpress/"
  ]
}

   provisioner "file" {
    source      = "./wp-config.php"
    destination = "/var/www/wordpress/"
  }
}