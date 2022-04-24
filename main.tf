terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = var.location
}

locals {
  list_instance_count = length(flatten([for i in var.vms : range(i["instance_count"])]))
  list_ami_id         = [for i in var.vms : i["ami_id"]]
  list_instance_type  = [for i in var.vms : i["instance_type"]]
  list_key_name       = [for i in var.vms : i["key_name"]]
  list_name           = tolist(keys(var.vms))
  list_ssh_user_name  = [for i in var.vms : i["ssh_user_name"]]
  list_ssh_key_path   = [for i in var.vms : i["ssh_key_path"]]
  list_subnet_id      = [for i in var.vms : i["subnet_id"]]
  list_private_ip     = [for i in var.vms : i["private_ip"]]
}

resource "aws_instance" "app_server" {
  count         = local.list_instance_count
  ami           = element(local.list_ami_id, count.index)
  instance_type = element(local.list_instance_type, count.index)
  key_name      = element(local.list_key_name, count.index)

  subnet_id     = element(local.list_subnet_id, count.index)
  private_ip    = element(local.list_private_ip, count.index)

  tags = {
    # The count.index allows you to launch a resource 
    # starting with the distinct index number 0 and corresponding to this instance.
    Name = element(local.list_name, count.index)
  }
}

resource "null_resource" "ProvisionRemoteHostsIpToAnsibleHosts" {
  count = local.list_instance_count
  connection {
    type        = "ssh"
    user        = element(local.list_ssh_user_name, count.index)
    private_key = file(pathexpand(element(local.list_ssh_key_path, count.index)))
    host        = element(aws_instance.app_server.*.public_ip, count.index)
  }

  # Copies all files and folders in provision/ to /tmp/
  provisioner "file" {
    source      = "provision/"
    destination = "/tmp/"
  }

  # Change permissions on bash script and execute.
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/prereq.sh",
      "sudo /tmp/prereq.sh",
    ]
  }

  # Change permissions on bash script and execute.
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_docker.sh",
      "sudo /tmp/install_docker.sh yes",
    ]
  }

  # Change permissions on bash script and execute.
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/run_sonarqube_container.sh",
      "sudo /tmp/run_sonarqube_container.sh ${element(local.list_name, count.index)}",
    ]
  }

  # Change permissions on bash script and execute.
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/run_nexus_container.sh",
      "sudo /tmp/run_nexus_container.sh ${element(local.list_name, count.index)}",
    ]
  } 

  # Change permissions on bash script and execute.
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/run_provision.sh",
      "sudo /tmp/run_provision.sh ${element(local.list_name, count.index)}",
    ]
  }
}  