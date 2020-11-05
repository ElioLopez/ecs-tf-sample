terraform {
  required_version = "~> 0.12"
}

provider "aws" {
  version = "~> 3.0"
  region                  = "eu-central-1"
 # shared_credentials_file = "~/.aws/credentials"
  profile                 = "workshop_dpvo_user"
}

terraform {
  backend "s3" {
    bucket = "test-app-dpvo-terraform-state-dev"
    key    = "terraform.tfstate"
    region = "eu-central-1"
    profile = "workshop_dpvo_user"
  }
}

module "ecs_app" {
  source = "git@github.com:freenet-group/ecs-tf-module.git?ref=v0.2.8-dev"

  app_name      = "test-app-dpvo"
  region        = "eu-central-1"
  environment   = "dev"

  dockerfile    = "Dockerfile"
  container = {
    port = 8080
    memory = 1024
    cpu = 512
  }

  database = {
    name = "demo"
    username  = "demo_user"
    password  = "demo_pass"     #this one can be later changed on AWS console
    engine = "mysql"
    version = "5.6"
    instance_class = "db.t2.micro"
    storage = 20
  }
}