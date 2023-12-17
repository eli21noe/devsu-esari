#provider "kubernetes" {
#  config_path    = "~/.kube/config"
#  config_context_cluster = "minikube"
#  version = "v2.1.0"
#}

provider "aws" {
  profile = "terraform"
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.2.0"
    }
  } 
  backend "s3" {
    bucket = "aston-lecture.springboot.simple-tf-remote-state"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }

}


