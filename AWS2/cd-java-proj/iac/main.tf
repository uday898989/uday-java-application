# Versions
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.40.0"
    }
  }
}
# Providers
provider "aws" {
  region = "us-east-1"
  #profile = "default"
}


data "template_file" "cb_user_data" {
  template = file("${path.module}/templates/install-tomcat.tpl")

  vars = {
    env = "dev"
  }
}

resource "aws_instance" "cb_tomcat" {
  ami                    = "ami-0574da719dca65348"
  instance_type          = "t2.medium"
  key_name               = "cloud-nv"
  subnet_id              = "subnet-00a07bb8fefdfcfec"
  vpc_security_group_ids = ["sg-0dfbc9513efa13349"]
  user_data              = data.template_file.cb_user_data.rendered

  tags = {
    Name      = "cb_tomcat"
    CreatedBy = "Terraform"
  }
}


