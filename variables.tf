#
# Module: tf_aws_asg
#

# Module specific variables
variable "name" {
  description = "Name prefix to be used in all resources as identifier"
  default = ""
}

# Launch Configuration variables
variable "ami_id" {
  description = "ID of AMI"
  default = ""
}
variable "instance_type" {
  description = "Type of instance"
  default = ""
}
variable "iam_instance_profile" {
  description = "ARN or name of IAM Role or instance profile"
}
variable "key_name" {
  description = "Name of SSH key pair to use for instances"
  default = ""
}
variable "security_group_ids" {
  description = "A list of security group IDs for instances"
  default = []
  type = "list"
}
variable "user_data" {
  description = "The path to a file with user_data for the instances"
  default = ""
}
variable "ebs_optimized" {
  description = "Flag to use EBS-optimized storage (true | false)"
  default = "true"
}

# Storage variables
variable "root_vol_del_on_termination" {
  description = "Flag to delete root volume on instance termination"
  default = true
}
variable "root_vol_iops" {
  description = "Amount of provisioned IOPS to use for root volume"
  default = ""
}
variable "root_vol_size" {
  description = "Size in GB of root volume"
  default = "10"
}
variable "root_vol_type" {
  description = "Type of root volume"
  default = "gp2"
}

variable "ebs_vol_device_name" {
  description = "Name of EBS volume"
  default = ""
}
variable "ebs_vol_del_on_termination" {
  description = "Flag to delete EBS volume on instance termination"
  default = true
}
variable "ebs_vol_snapshot_id" {
  description = "ID of snapshot to use for EBS volume"
  default = ""
}
variable "ebs_vol_iops" {
  description = "Amount of provisioned IOPS to use for EBS volume"
  default = ""
}
variable "ebs_vol_size" {
  description = "Size in GB of EBS volume"
  default = "10"
}
variable "ebs_vol_type" {
  description = "Type of EBS volume"
  default = "gp2"
}

# Auto-Scaling Group
variable "asg_instances" {
  description = "The number of instances we want in the ASG"
  default = ""
  # We use this to populate the following ASG settings
  # - max_size
  # - desired_capacity
}
variable "asg_min_instances" {
  description = "The minimum number of instances the ASG should maintain"
  default = 1
  # Defaults to 1
  # Can be set to 0 if you never want the ASG to replace failed instances
}
variable "health_check_grace_period" {
  description = "Number of seconds after instance is in service before starting health check"
  default = 300
}
variable "health_check_type" {
  description = "Type of instance health check (EC2 | ELB)"
  default = "EC2"
}
variable "cooldown_time" {
  description = "Number of seconds between scaling events"
  default = 120
}
variable "protect_scale_in" {
  description = "Flag to protect instances from termination during scale in"
  default = "false"
}
variable "subnet_ids" {
  description = "A list of subnet IDs in which to launch instances"
  default = []
  type = "list"
}
variable "tags" {
  description = "A list of a map of key/value pairs for tags to add to all resources"
  default = []
  type = "list"
}
