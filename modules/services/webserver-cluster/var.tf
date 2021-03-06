variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 8080
}

variable "cluster_name" {
  description = "The name to use for all the cluster resources"
}

variable "db_remote_state_bucket" {
  description = "The path for the database's remote state in s3"
}

variable "db_remote_state_key" {
  description = "The path for the database's remote state in s3"
}

variable "instance_type" {
  description = "The type of EC2 instances to run (e.g. t2.micro"
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
}

variable "elb_name" {
  description = "ELB name"
}


#variable "s3_remote_state_bucket" {
#  description = "Remote State S3 bucket name"
#}
#variable "webserver_remote_state_key" {
#  description = "Remote State file name for webserver in S3 bucket name"
#}

