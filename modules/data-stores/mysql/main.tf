resource "aws_db_instance" "db_example" {
  engine            = "${var.db_engine}"
  allocated_storage = "${var.db_allocated_storage}"
  instance_class    = "${var.db_instance_class}"
  name              = "${var.db_name}"
  username          = "${var.db_username}"
  password          = "${var.db_password}"
}
