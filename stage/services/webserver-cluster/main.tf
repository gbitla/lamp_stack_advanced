provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  source                 = "../../../modules/services/webserver-cluster"
  cluster_name           = "webserver-stage"
  elb_name               = "webserver-stage-elb"
  db_remote_state_bucket = "gb1-master-tf-state-advanced"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"
  instance_type          = "t2.micro"
  min_size               = 2
  max_size               = 2
}

terraform {
  backend "s3" {
    bucket         = "gb1-master-tf-state-advanced"
    key            = "stage/services/webserver-cluster/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-advanced"
  }
}
