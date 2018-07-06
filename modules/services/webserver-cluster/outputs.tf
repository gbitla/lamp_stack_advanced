output "launch_configuration_id" {
  value = "${aws_launch_configuration.example.id}"
}

output "security_groups" {
  value = "${aws_security_group.elb-sg.id}"
}

output "elb_dns_name" {
  value = "${aws_elb.example.dns_name}"
}

output "asg_name" {
  value = "${aws_autoscaling_group.example.name}"
}
