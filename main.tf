#
# Module: tf_aws_asg
#

# This template creates the following resources
# - A launch configuration
# - An auto-scaling group
# - It's meant to be used for ASGs that *don't*
#   need an ELB associated with them.

# Create specific LC based on if EBS is requested
resource "aws_launch_configuration" "lc" {
  count = "${length(var.ebs_vol_device_name) > 0 ? 0 : 1}"

  ebs_optimized = "${var.ebs_optimized}"
  enable_monitoring = true
  iam_instance_profile = "${var.iam_instance_profile}"
  image_id = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  name = "${var.name}-lc"
  security_groups = ["${var.security_group_ids}"]
  user_data = "${file(var.user_data)}"

  root_block_device {
    delete_on_termination = "${var.root_vol_del_on_termination}"
    iops = "${var.root_vol_type == "io1" ? var.root_vol_iops : "0"}"
    volume_size = "${var.root_vol_size}"
    volume_type = "${var.root_vol_type}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "lc_ebs" {
  count = "${length(var.ebs_vol_device_name) > 0 ? 1 : 0}"

  ebs_optimized = "${var.ebs_optimized}"
  enable_monitoring = true
  iam_instance_profile = "${var.iam_instance_profile}"
  image_id = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  name = "${var.name}-lc"
  security_groups = ["${var.security_group_ids}"]
  user_data = "${file(var.user_data)}"

  root_block_device {
    delete_on_termination = "${var.root_vol_del_on_termination}"
    iops = "${var.root_vol_type == "io1" ? root_vol_iops : "0"}"
    volume_size = "${var.root_vol_size}"
    volume_type = "${var.root_vol_type}"
  }

  ebs_block_device {
    delete_on_termination = "${var.ebs_vol_del_on_termination}"
    device_name = "${var.ebs_vol_device_name}"
    encryption = "${length(var.ebs_vol_snapshot_id) > 0 ? "" : "true"}"
    iops = "${var.ebs_vol_type == "io1" ? var.ebs_vol_iops : "0"}"
    snapshot_id = "${var.ebs_vol_snapshot_id}"
    volume_size = "${var.ebs_vol_size}"
    volume_type = "${var.ebs_vol_type}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create ASG based on LC created
resource "aws_autoscaling_group" "asg" {
  count = "${length(var.ebs_vol_device_name) > 0 ? 0 : 1}"
  depends_on = ["aws_launch_configuration.lc"]

  default_cooldown = "${var.cooldown_time}"
  desired_capacity = "${var.asg_instances}"
  enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type = "${var.health_check_type}"
  launch_configuration = "${aws_launch_configuration.lc.id}"
  max_size = "${var.asg_instances}"
  metrics_granularity = "1Minute"
  min_size = "${var.asg_min_instances}"
  name = "${var.name}-asg"
  protect_from_scale_in = "${var.protect_scale_in}"
  vpc_zone_identifier = "${var.subnet_ids}"

  tags   = "${concat(list(map("key", "Name", "value", format("%s-asg-ec2", var.name), "propagate_at_launch", true)), var.tags)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg_ebs" {
  count = "${length(var.ebs_vol_device_name) > 0 ? 1 : 0}"
  depends_on = ["aws_launch_configuration.lc_ebs"]

  default_cooldown = "${var.cooldown_time}"
  desired_capacity = "${var.asg_instances}"
  enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type = "${var.health_check_type}"
  launch_configuration = "${aws_launch_configuration.lc_ebs.id}"
  max_size = "${var.asg_instances}"
  metrics_granularity = "1Minute"
  min_size = "${var.asg_min_instances}"
  name = "${var.name}-asg"
  protect_from_scale_in = "${var.protect_scale_in}"
  vpc_zone_identifier = "${var.subnet_ids}"

  tags   = "${concat(list(map("key", "Name", "value", format("%s-asg-ec2", var.name), "propagate_at_launch", true)), var.tags)}"

  lifecycle {
    create_before_destroy = true
  }
}
