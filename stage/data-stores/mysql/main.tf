provider "aws" {
  region = "us-east-1"
}

module "rds_database" {
  source               = "../../../modules/data-stores/mysql"
  db_engine            = "mysql"
  db_allocated_storage = 10
  db_instance_class    = "db.t2.micro"
  db_name              = "stage_example_database"
  db_username          = "admin"
  db_password          = "${var.db_password}"
}

terraform {
  backend "s3" {
    bucket         = "gb1-master-tf-state-advanced"
    key            = "stage/data-stores/mysql/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-advanced"
  }
}
