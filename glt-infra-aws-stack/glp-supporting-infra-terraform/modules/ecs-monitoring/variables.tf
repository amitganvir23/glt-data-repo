/*
   Variables for ECS_CLUSTER
*/


variable "keypair_public_key" {}
variable "glt-vpc-id" {}
variable "region" {}
variable "aws_key_name" {}
variable "environment" {}
variable "monitoringcluster_instance_type" {}
variable "efs_data_dir" {}
variable "efs_fs_id" {}
variable "bastion_sg_id" {}
#variable "vpc_sg_id" {}
variable "ami_owner_name" {}
variable "ami_name_regex" {}
variable "vpc_cidr" {}

// ASG
variable "ecs_monitoring_asg_max_size" {}
variable "ecs_monitoring_asg_min_size" {}
variable "ecs_monitoring_asg_desired_size" {}

variable "load_balancers" {
    default = []
}

variable "private_subnet_ids" {
   default = []
}

variable "dependency_id" {
  default = ""
}

variable "public_sub_cidr" {
     default = []
}

variable "private_sub_cidr" {
     default = []
}

variable "control_cidr" {
}
