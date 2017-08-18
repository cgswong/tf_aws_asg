# tf_aws_asg

A Terraform module for creating an Auto-Scaling Group and a launch configuration for it. This module makes the following assumptions:

* *You do not want an ELB associated with your ASG*
   * If you need ELB support, see [tf_aws_asg_elb](https://github.com/terraform-community-modules/tf_aws_asg_elb)
* You have subnets in a VPC
* You want your instance in N subnets
* You can fully bootstrap your instances using an AMI + user_data
* You're using a single Security Group for all instances in the ASG

## Input Variables

* `name` - Prefix name for resources.
* `ami_id` - ID of AMI to use in LC.
* `instance_type` - Type of AMI to use in LC.
* `iam_instance_profile` - The name or ARN (preferred) of the IAM Role (Instance Profile) the LC should use for instances.
   E.g. arn:aws:iam::XXXXXXXXXXXX:instance-profile/my-instance-profile
* `key_name` - The SSH key name (uploaded to EC2) instances should use.
* `security_group_ids` - A list of the Security Group IDs that instances in the ASG will use to be accessed.
    * This is usually set to resolve to a security group you make in the
      same template as this module, e.g. "${module.sg_web.security_group_id_web}"
    * It needs to be customized based on the name of your module resource.
* `user_data` - The path to the user data file for the LC.
    * Terraform will include the contents of this file in the LC.
* `ebs_optimized` - Flag which indicates if EBS optimized storage should be used (should leave as default "true").
* `root_vol_del_on_terminate` - Flag to delete root volume on instance termination (default to "true").
* `root_vol_size` - Size in GB of root volume (defaults to "10").
* `root_vol_type` - Specify the type of storage to use for the root volume, i.e. `io1` (provisioned IOPS SSD), `standard` (magnetic HDD), or the default `gp2` (general purpose SSD).
* `root_vol_iops` - When using `io1` storage type for the root volume, specify the amount of IOPS to use.
* `ebs_vol_device_name` - Name to use for device of attached EBS volume.
* `ebs_vol_snapshot_id` - ID of a snapshot to use for an attached EBS volume.
* `ebs_vol_del_on_terminate` - Flag to delete attached EBS volume on instance termination (default to "true").
* `ebs_vol_size` - Size in GB of attached EBS volume (defaults to "10"). **Must be 500+ GB for `st1` or `sc1` volume types.**
* `ebs_vol_type` - Specify the type of storage to use for an attached EBS volume, i.e. `io1` (provisioned IOPS SSD), `standard` (magnetic HDD), `st1` (throughput optimized HDD), `sc1` (cold HDD) or the default `gp2` (general purpose SSD).
* `ebs_vol_iops` - When using `io1` storage type for an attached EBS volume, specify the amount of IOPS to use.
* `asg_instances` - The number of instances we want in the ASG. This is used to populate the following ASG settings:
    * max_size
    * desired_capacity
- `asg_min_instances` - The minimum number of instances the ASG should maintain.
    * This is used for min_size
    * It defaults to 1
    * You can set it to 0 if you want the ASG to do nothing when an instances fails
* `health_check_grace_period` - Number of seconds for the health check time out. Defaults to 300.
* `health_check_type` - The health check type. Options are `ELB` and `EC2`. It defaults to `EC2` in this module.
* `cooldown_time` - Number of seconds between which scaling events can occur.
* `subnet_ids` - The list of subnet IDs in the VPC in which the ASG will launch instances.
* `tags` - A list of a map of key/value pairs to tag all resources launched from the ASG.


## Outputs

* `lc_id`: ID of Launch Configuration
* `lc_name`: Name of Launch Configuration
* `asg_id`: ID of ASG
* `asg_name`: Name of ASG

## Usage

You can use these in your Terraform template with the following steps:

1. Adding a module resource to your template, e.g. `main.tf`

    ```
    module "my_asg" {
      source               = "github.com/terraform-community-modules/tf_aws_asg"
      name                 = "${var.name}"
      ami_id               = "${var.ami_id}"
      instance_type        = "${var.instance_type}"
      iam_instance_profile = "${var.iam_instance_profile}"
      key_name             = "${var.key_name}"

      # Using a reference to a SG we create in the same template.
      # - It needs to be customized based on the name of your module resource
      security_group_ids = "${module.sg_web.security_group_id_web}"

      user_data         = "${var.user_data}"
      asg_instances     = "${var.asg_instances}"
      asg_min_instances = "${var.asg_min_instances}"

      # The health_check_type can be EC2 or ELB and defaults to EC2
      health_check_type = "${var.health_check_type}"
      
      subnet_ids = "${var.subnet_ids}"
    }
    ```

2. Setting values for the following variables, either through `-var-file=terraform.tfvars` or `-var` arguments on the CLI

    - name
    - ami_id
    - instance_type
    - iam_instance_profile
    - key_name
    - security_group_ids
    - user_data
    - asg_instances
    - subnet_ids

# Authors

Created and maintained by [Brandon Burton](https://github.com/solarce) (brandon@inatree.org).

# License

Apache 2 Licensed. See LICENSE for full details.
