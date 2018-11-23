/*
   Variables for all modules
*/


// VPC
variable "region" {}
variable "vpc_cidr" {}
variable "aws_key_path" {}
variable "aws_key_name" {}
variable "keypair_public_key" {}
variable "vpc_name" {}
variable "environment" {}
variable "private_sub_control_cidr" {}
variable "control_cidr" {}
variable "proxy_cidr" {}
variable "ami_owner_name" {}
variable "ami_name_regex" {}
variable "ansible_ssh_user" {}

//jenkins
variable "jenkins-master-ami" {}
variable "jenkins-slave-ami" {}

// Route53
variable "main_zone_id" {}
variable "public_domain_name" {}

// ASG size for each cluster

// Generic
variable "azs" {
    default = []
}

variable "public_sub_cidr" {
     default = []
}

variable "private_sub_cidr" {
     default = []
}

// Monitoring Cluster EFS
variable "efs_monitoring_data_dir" {}

// Declare classes of instances for each modules
variable "bastion_instance_type" {}
variable "monitoringcluster_instance_type" {}

//jenkins
variable "jenkins_slave_instance_type" {}
variable "jenkins_master_instance_type" {}


// ASG size for each cluster
variable "ecs_monitoring_asg_max_size" {}
variable "ecs_monitoring_asg_min_size" {}
variable "ecs_monitoring_asg_desired_size" {}

// ELB jenkins
variable "jenkins_elb_name" {}
variable "jenkins_elb_sg_name" {}
variable "jenkins_elb_healthy_threshold" {}
variable "jenkins_elb_unhealthy_threshold" {}
variable "jenkins_elb_timeout" {}
variable "jenkins_elb_elb_health_target" {}
variable "jenkins_elb_interval" {}
variable "jenkins_ssl_certificate_id" {}

// ELB Monitoring
variable "monitoring_elb_name" {}
variable "monitoring_elb_sg_name" {}
variable "monitoring_elb_healthy_threshold" {}
variable "monitoring_elb_unhealthy_threshold" {}
variable "monitoring_elb_timeout" {}
variable "monitoring_elb_elb_health_target" {}
variable "monitoring_elb_interval" {}
variable "monitoring_ssl_certificate_id" {}
