variable "location" {
  description = "The location/region where the core network will be created."
  default     = "sa-east-1"
}

variable "vms" {
  #type = map(string)
  default = {
    "cicd" = {
      "ami_id"         = "ami-02e2a5679226e293c"
      "instance_type"  = "t2.micro"
      "key_name"       = "acesso"
      "instance_count" = 1
      "ssh_user_name"  = "admin"
      "ssh_key_path"   = "~/Downloads/acesso.pem"
      "subnet_id"      = "subnet-032538fd3576b33ff"
      "private_ip"     = "172.31.56.10"   
    },
    "cicd-tools" = {
      "ami_id"         = "ami-02e2a5679226e293c"
      "instance_type"  = "t2.medium"
      "key_name"       = "acesso"
      "instance_count" = 1
      "ssh_user_name"  = "admin"
      "ssh_key_path"   = "~/Downloads/acesso.pem"
      "subnet_id"      = "subnet-032538fd3576b33ff"
      "private_ip"     = "172.31.56.20"
    },
    "homolog" = {
      "ami_id"         = "ami-02e2a5679226e293c"
      "instance_type"  = "t2.micro"
      "key_name"       = "acesso"
      "instance_count" = 1
      "ssh_user_name"  = "admin"
      "ssh_key_path"   = "~/Downloads/acesso.pem"
      "subnet_id"      = "subnet-032538fd3576b33ff"
      "private_ip"     = "172.31.56.30"   
    },
    "production" = {
      "ami_id"         = "ami-02e2a5679226e293c"
      "instance_type"  = "t2.micro"
      "key_name"       = "acesso"
      "instance_count" = 1
      "ssh_user_name"  = "admin"
      "ssh_key_path"   = "~/Downloads/acesso.pem"
      "subnet_id"      = "subnet-032538fd3576b33ff"
      "private_ip"     = "172.31.56.40"   
    },
    
  }
}