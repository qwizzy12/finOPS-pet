terraform {
  required_version = ">= 1.16.4"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.100.0"
    }
  }
}

data "yandex_compute_image" "latest_ubuntu" {
  family = "ubuntu-24-04-lts"
}

data "yandex_vpc_network" "default" {
  name = "default"
}

data "yandex_vpc_subnet" "default_a" {
  name = "default-ru-central1-a"
}

provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id                 = "var.cloud_id"
  folder_id                = "var.folder_id"
  zone                     = "ru-central1-a"
}

resource "yandex_compute_instance" "devops_vm" {
  name        = "junior-devops-pet"
  platform_id = "standard-v3" 

  resources {
    cores         = 2  
    memory        = 4  
    core_fraction = 20  
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.latest_ubuntu.id
      size     = 30                     
      type     = "network-hdd"          
    }
  }

  network_interface {
    subnet_id = data.yandex_vpc_subnet.default_a.id
    nat       = true 
  }

  metadata = {
    ssh-keys = "ubuntu:${file(pathexpand("~/.ssh/id_rsa.pub"))}"
  }
}

output "vms_external_ip" {
  value       = yandex_compute_instance.devops_vm.network_interface.0.nat_ip_address
  description = "IP твоего нового сервера"
}
variable "cloud_id" {
  type = string
  description = "ID cloud yandex"
}

variable "folder_id" {
  type = string
  description = "ID folder cloud yandex"
}
