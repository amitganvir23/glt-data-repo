/*
-----------------------------------------------------------------
- This deploys entire application stack
- Environment variable will control the naming convention
- Setup creds and region via env variables
- For more details: https://www.terraform.io/docs/providers/aws
-----------------------------------------------------------------
Notes:
 - control_cidr changes for different modules
 - Instance class also changes for different modules
 - Bastion should be minimum t2.medium as it would be executing config scripts
 - Default security group is added where traffic is supposed to flow between VPC
 */

/********************************************************************************/
provider "aws" {
  region = "${var.region}"
}

// Use my terraform version :-)
// Use `terraform init`
terraform {
  required_version = ">= 0.9, <= 0.9.6"
  backend "s3" {
  bucket     = "terraform-glt-remote-state"
  key        = "terraform.tfstate-supporting-glt"
  region     = "us-east-1"
  encrypt    = "true"
  lock_table = "terraform-state"
  }
}
/****
/********************************************************************************/



module "glt-vpc" {
   source                   = "../modules/vpc"
   azs                      = "${var.azs}"
   vpc_cidr                 = "${var.vpc_cidr}"
   public_sub_cidr          = "${var.public_sub_cidr}"
   private_sub_cidr         = "${var.private_sub_cidr}"
   enable_dns_hostnames     = true
   vpc_name                 = "${var.vpc_name}-${var.environment}"
   environment              = "${var.environment}"
}

module "bastion" {
   source                = "../modules/bastion"
   public_sub_cidr       = "${var.public_sub_cidr}"
   glt-vpc-id            = "${module.glt-vpc.vpc_id}"
   pub_sub_id            = "${module.glt-vpc.aws_pub_subnet_id[0]}"
   region                = "${var.region}"
   bastion_instance_type = "${var.bastion_instance_type}"
   keypair_public_key    = "${var.keypair_public_key}"
   aws_key_name          = "${var.aws_key_name}"
   control_cidr          = "${var.control_cidr}"
   ansible_ssh_user      = "${var.ansible_ssh_user}"
   proxy_cidr            = "${var.proxy_cidr}"
   environment           = "${var.environment}"
}

module "jenkins-master" {
   source                = "../modules/jenkins-master"
   public_sub_cidr       = "${var.public_sub_cidr}"
   glt-vpc-id            = "${module.glt-vpc.vpc_id}"
   pub_sub_id            = "${module.glt-vpc.aws_pub_subnet_id[0]}"
   region                = "${var.region}"
   jenkins_master_instance_type = "${var.jenkins_master_instance_type}"
   jenkins-master-ami    = "${var.jenkins-master-ami}"
   keypair_public_key    = "${var.keypair_public_key}"
   aws_key_name          = "${var.aws_key_name}"
   bastion_sg_id         = "${module.bastion.bastion-sg-id}"
   vpc_cidr              = "${var.vpc_cidr}"
   control_cidr          = "${var.control_cidr}"
   ansible_ssh_user      = "${var.ansible_ssh_user}"
   proxy_cidr            = "${var.proxy_cidr}"
   environment           = "${var.environment}"
}

module "jenkins-slave" {
   source                = "../modules/jenkins-slave"
   public_sub_cidr       = "${var.public_sub_cidr}"
   glt-vpc-id            = "${module.glt-vpc.vpc_id}"
   pub_sub_id            = "${module.glt-vpc.aws_pub_subnet_id[0]}"
   region                = "${var.region}"
   jenkins_slave_instance_type = "${var.jenkins_slave_instance_type}"
   jenkins-slave-ami     = "${var.jenkins-slave-ami}"
   keypair_public_key    = "${var.keypair_public_key}"
   aws_key_name          = "${var.aws_key_name}"
   bastion_sg_id         = "${module.bastion.bastion-sg-id}"
   vpc_cidr              = "${var.vpc_cidr}"
   control_cidr          = "${var.control_cidr}"
   ansible_ssh_user      = "${var.ansible_ssh_user}"
   proxy_cidr            = "${var.proxy_cidr}"
   environment           = "${var.environment}"
}

module "jenkins-external-elb" {
   source              = "../modules/elb-jenkins"
   vpc_id              = "${module.glt-vpc.vpc_id}"
   subnets             = "${module.glt-vpc.aws_pub_subnet_id}"
   elb_is_internal     = "false"
   jenkins_master_id   = "${module.jenkins-master.jenkins_master_id}"
   elb_name            = "${var.jenkins_elb_name}-${var.environment}"
   elb_control_cidr    = "${var.control_cidr}"
   elb_sg_name         = "${var.jenkins_elb_sg_name}"
   healthy_threshold   = "${var.jenkins_elb_healthy_threshold}"
   unhealthy_threshold = "${var.jenkins_elb_unhealthy_threshold}"
   timeout             = "${var.jenkins_elb_timeout}"
   elb_health_target   = "${var.jenkins_elb_elb_health_target}"
   interval            = "${var.jenkins_elb_interval}"
   ssl_certificate_id  = "${var.jenkins_ssl_certificate_id}"
   environment         = "${var.environment}"
}

module "monitoring-external-elb" {
   source              = "../modules/elb-monitoring"
   vpc_id              = "${module.glt-vpc.vpc_id}"
   subnets             = "${module.glt-vpc.aws_pub_subnet_id}"
   elb_is_internal     = "false"
   elb_name            = "${var.monitoring_elb_name}-${var.environment}"
   elb_control_cidr    = "${var.control_cidr}"
   elb_sg_name         = "${var.monitoring_elb_sg_name}"
   healthy_threshold   = "${var.monitoring_elb_healthy_threshold}"
   unhealthy_threshold = "${var.monitoring_elb_unhealthy_threshold}"
   timeout             = "${var.monitoring_elb_timeout}"
   elb_health_target   = "${var.monitoring_elb_elb_health_target}"
   interval            = "${var.monitoring_elb_interval}"
   ssl_certificate_id  = "${var.monitoring_ssl_certificate_id}"
   environment         = "${var.environment}"
}

module "ecs-monitoring-cluster" {
   source                   = "../modules/ecs-monitoring"
   private_subnet_ids       = "${module.glt-vpc.aws_pri_subnet_id}"
   glt-vpc-id               = "${module.glt-vpc.vpc_id}"
   region                   = "${var.region}"
   keypair_public_key       = "${var.keypair_public_key}"
   aws_key_name             = "${var.aws_key_name}"
   control_cidr             = "${var.private_sub_control_cidr}"
   monitoringcluster_instance_type = "${var.monitoringcluster_instance_type}"
   load_balancers           = [ "${module.monitoring-external-elb.monitoring-external-elb-name}"]
   bastion_sg_id            = "${module.bastion.bastion-sg-id}"
   efs_data_dir             = "${var.efs_monitoring_data_dir}"
   efs_fs_id                = "${module.efs-private-subnet.efs_fs_id}"
   environment              = "${var.environment}"
   ecs_monitoring_asg_max_size     = "${var.ecs_monitoring_asg_max_size}"
   ecs_monitoring_asg_min_size     = "${var.ecs_monitoring_asg_min_size}"
   ecs_monitoring_asg_desired_size = "${var.ecs_monitoring_asg_desired_size}"
   ami_owner_name           = "${var.ami_owner_name}"
   ami_name_regex           = "${var.ami_name_regex}"
   vpc_cidr                 = "${var.vpc_cidr}"
}

module "efs-private-subnet" {
   source                = "../modules/efs"
   efs_cluster_name      = "efs_infra_private_subnet"
   count                 = "${length(var.azs)}"
   subnet_ids            = "${module.glt-vpc.aws_pri_subnet_id_str}"
   environment           = "${var.environment}"
   // We need SGs for all instances where EFS is to be launched
   security_group_id     = [
                             "${module.ecs-monitoring-cluster.monitoring-cluster-sg-id}"
                           ]
}
/*
module "ansible-ecs-setup" {
   source                        = "../modules/ansible-ecs"
   env                           = "${var.environment}"
   region                        = "${var.region}"
   route53_domain                = "${var.public_domain_name}"
   # This is only used for Couchbase server
   route53_private_domain        = "${var.environment}-internal.com"
   # These add explicit dependencies
   dependency_id          = [

                                 "${module.ecs-monitoring-cluster.dependency_id}"

                            ]
}
*/
