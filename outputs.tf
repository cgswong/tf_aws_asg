#
# Module: tf_aws_asg
#

output "lc_id" {
  value = "${coalesce(join(",", aws_launch_configuration.lc.id), join(",", aws_launch_configuration.lc_ebs.id))}"
}

output "lc_name" {
  value = "${coalesce(join(",", aws_launch_configuration.lc.name), join(",", aws_launch_configuration.lc_ebs.name))}"
}

output "asg_id" {
  value = "${coalesce(join(",", aws_autoscaling_group.asg.id), join(",", aws_autoscaling_group.asg_ebs.id))}"
}

output "asg_name" {
  value = "${coalesce(join(",", aws_autoscaling_group.asg.name), join(",", aws_autoscaling_group.asg_ebs.name))}"
}
