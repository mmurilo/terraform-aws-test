variable "account_file" {
  description = "GCloud json file"
  type        = string
  default     = "packer-ops.json"
}

variable "username" {
  description = "username"
  type        = string
  default     = "zenhub"
}

source "googlecompute" "zenhub_ops" {
  project_id                      = "zenhub-ops"
  source_image_family             = "ubuntu-2004-lts"
  zone                            = "us-west1-a"
  account_file                    = var.account_file
  disable_default_service_account = true
  image_name                      = "marcos-test-packer-{{timestamp}}"
  preemptible                     = true
  ssh_username                    = var.username
  skip_create_image               = true
}

build {
  sources = ["sources.googlecompute.zenhub_ops"]
  provisioner "shell" {
    inline = ["echo hello packer world from GCloud"]
  }
  provisioner "ansible" {
      playbook_file = "./playbook.yml"
    #   extra_arguments = ["-vvv"]
      user = var.username
    }
  provisioner "shell" {
    inline = ["echo Build Successful !!!"]
  }
}

