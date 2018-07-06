variable "db_password" {
  description = "The password for the database"
}

variable "db_name" {
  description = "The name to use for all the cluster resources"
}

variable "db_instance_class" {
  description = "The type of DB instances to run (e.g. db.t2.micro)"
}

variable "db_allocated_storage" {
  description = "DB allocated storage"
}

variable "db_username" {
  description = "DB user name"
}
variable "db_engine" {
  description = "DB Engine to use"
}