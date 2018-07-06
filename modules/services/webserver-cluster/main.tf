data "aws_availability_zones" "all" {}

#defining template_file data source which as two parameters; the template parameter, 
#which is a string, and the vars parameters whic is map of variables

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.sh")}"

  vars {
    server_port = "${var.server_port}"

    #db_address  = "${data.terraform_remote_state.db.address}"
    #db_port = "${data.terraform_remote_state.db.port}"
  }
}

resource "aws_launch_configuration" "example" {
  #count         = 3
  image_id      = "ami-2d39803a"
  instance_type = "${var.instance_type}"

  #interpolation implicitly calling security group
  security_groups = ["${aws_security_group.instance-sg.id}"]

  user_data = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "instance-sg" {
  name = "${var.cluster_name}-instance-sg"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_http_inbound1" {
  type              = "ingress"
  security_group_id = "${aws_security_group.instance-sg.id}"

  from_port   = "${var.server_port}"
  to_port     = "${var.server_port}"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example.id}"

  #availability_zones = ["${data.aws_availability_zones.all.names}"]
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  load_balancers     = ["${aws_elb.example.name}"]
  health_check_type  = "ELB"

  min_size = "${var.min_size}"
  max_size = "${var.max_size}"

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}"
    propagate_at_launch = true
  }
}

resource "aws_elb" "example" {
  name               = "${var.elb_name}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  security_groups    = ["${aws_security_group.elb-sg.id}"]

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "${var.server_port}"
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:${var.server_port}/"
  }
}

resource "aws_security_group" "elb-sg" {
  name = "${var.cluster_name}-elb"

  #name = "terraform-example-elb"
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.elb-sg.id}"

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  security_group_id = "${aws_security_group.elb-sg.id}"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

#Get the web server cluster code to read the data from this state file
#by adding the terraform_remote_state data source

data "terraform_remote_state" "db" {
  backend = "s3"

  config {
    bucket = "${var.db_remote_state_bucket}"
    key    = "${var.db_remote_state_key}"
    region = "us-east-1"
  }
}

#terraform {
#  backend "s3" {
#    bucket         = "${var.s3_remote_state_bucket}"
#    key            = "${var.webserver_remote_state_key}"
#    region         = "us-east-1"
#    encrypt        = true
#    dynamodb_table = "terraform-lock"
#  }
#}

