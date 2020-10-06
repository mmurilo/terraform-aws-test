variable "access_key" {}
variable "secret_key" {}
variable "aws_region" { default = "ca-central-1" }
variable "vpc_cidr" { default = "10.1.0.0/16" }
variable "resource_prefix" { default = "test" }


variable "vpc_azs_id" {
  type    = list(string)
  default = ["cac1-az1", "cac1-az2"]
}
variable "vpc_public_subnets" {
  type    = list(string)
  default = ["10.1.3.0/24"]
}
variable "vpc_private_subnets" {
  type    = list(string)
  default = ["10.1.1.0/24", "10.1.2.0/24"]
}

# variable "pub_key" { default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0JJvt6hCOM97qciwD/B2c8A+keUipgDHZr7Dcn7fDQedK8B3rF+3TEVTzhs/nvEFdVEz5SXuHst/67i/+cXmV9mrJWuG8h2jh0XD9LBu2d38VisAIQGJgqbayaq+MD43s4kReJ72kNlDCwclCAFi2eVnYddPzh5JPMkWo1S6YTN5NcFk2O34O5tSf73lyt4+0t3ccl0W7rdUGIiFzLx/peBevCijnra5TrhFZrN7wO+q/DMtb0Wm0HJp9lGG1Xo1BaOYGKSFglQSOEXhReBjGH8IsXJzDeQAw7szFSpchQN4igwpeOkrXnVBXWyIoEjesryUMiwkRTKwUb43VyyFw3zJcfRnM9a/ofZAoQ96xL1C/7JIpXKFXPFF+GUXL7zX+xSHjp+4P2ASEc4rJXYXKvWGzvJ+ZpcwBufJ2FqOQ1sraid/qUaPXlUGyivhb2ZhBhLhyZy02u/GrwUehW6J1ARFcG9mk6fDt4owJPTJFDYaFefSQfQoQjP3E02bRxk87zMRNS2qv/USgBYd2yo9jX+2U9LqxzDC6UQ4NVGWbOopobtgNYVX6nVTuqReHiZ1p5kvZhyfvvNLeE7wIKT5FSH2MULcZMUq8G77/qskuoP+DounyvSk12UD9eAFfapLQmUBZ7lkDU9lZ8NyBaedSuxPMv3/cXVqRPoYGjlwxBQ== marcos@zenhub.com" }
variable "pub_key" {}
variable "jumpbox_key_name" { default = "jumpbox" }

#tags
variable "default_tags" {
  type = map(string)
  default = {
    Creator = "Marcos"
    Tier    = "test"
  }
}
