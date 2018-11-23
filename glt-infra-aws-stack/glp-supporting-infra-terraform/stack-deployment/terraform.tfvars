/*
 Variables for deploying stack
--------------------------------
- ACM certificates have to pre-exist
*/

// General
region            = "ap-southeast-2"
vpc_name          = "GLT-Infra"
vpc_cidr          = "172.168.0.0/16"
proxy_cidr        = "172.2.*"
environment       = "supporting"

/* Classes of instances - has to change based on environment
- Please choose between the following only
- [dev|qa|stage]
*/
bastion_instance_type               = "t2.micro"
monitoringcluster_instance_type     = "t2.large"
jenkins_slave_instance_type         = "t2.medium"
jenkins_master_instance_type         = "t2.medium"

# Ansible auto ssh
ansible_ssh_user  = "ec2-user"
ansible_user      = "ansible"

# AZs are combintation of az length + subnet cidrs
public_sub_cidr   = ["172.168.0.0/24","172.168.1.0/24"]
private_sub_cidr  = ["172.168.3.0/24","172.168.4.0/24"]
azs               = ["ap-southeast-2a","ap-southeast-2b"]


// For public facing sites and ELBs
// remove 223.176.0.0/16 after a week
// remove 34.207.47.108 after demo
control_cidr = "202.174.0.0/32,139.5.0.0/16,34.193.0.0/16,115.249.0.0/16,159.182.0.0/16,42.111.0.0/16,192.251.0.0/16,54.82.34.148/32,27.5.0.0/16,52.14.5.155/32,223.176.0.0/16,34.207.47.108/32,52.89.89.192/32,27.50.5.103/32"

// ASG Size
# ECS monitoring cluster
ecs_monitoring_asg_max_size = 2
ecs_monitoring_asg_min_size = 1
ecs_monitoring_asg_desired_size = 1

// Route53
main_zone_id       = "Z2WUFSTRXBZ83"
public_domain_name = "gl-poc.com"
# Our internal domain is fixed to internal.com


// DHCP servers
# Not using because WEAVE integration. NW
# http://stackoverflow.com/questions/28716247/docker-weave-dns-not-resolving-on-other-host?noredirect=1&lq=1
# domain_servers = "172.17.0.1,10.2.0.2"

// Same as vpc cidr for now
private_sub_control_cidr ="172.168.0.0/16"

// efs
efs_monitoring_data_dir = "/monitoring-data"

// AMIs to be used based on owner name and ami name regex
# Using Weave-ECS AMI
# ami_owner_name   = OwnerId

ami_owner_name   = "376248598259"
ami_name_regex   = "Weaveworks*ECS*Image*"

//jenkins
jenkins-master-ami = "ami-66a5ba05"
jenkins-slave-ami  = "ami-baa3bcd9"

// Jenkins-external-elb
jenkins_elb_name                = "jenkins-external"
jenkins_elb_sg_name             = "jenkins-external-elb-sg"
jenkins_elb_healthy_threshold   = 10
jenkins_elb_unhealthy_threshold = 2
jenkins_elb_timeout             = 10
jenkins_elb_elb_health_target   = "TCP:8080"
jenkins_elb_interval            = "15"
// Certificate must be available in IAM or ACM and must match region being deployed in
jenkins_ssl_certificate_id      = "arn:aws:acm:ap-southeast-2:953030164212:certificate/427dd159-515e-4be5-a1a6-0095195222f1"

// Monitoring-external-elb
monitoring_elb_name                = "monitoring-external"
monitoring_elb_sg_name             = "monitoring-external-elb-sg"
monitoring_elb_healthy_threshold   = 10
monitoring_elb_unhealthy_threshold = 2
monitoring_elb_timeout             = 10
monitoring_elb_elb_health_target   = "TCP:3000"
monitoring_elb_interval            = "15"
// Certificate must be available in IAM or ACM and must match region being deployed in
monitoring_ssl_certificate_id      = "arn:aws:acm:ap-southeast-2:953030164212:certificate/427dd159-515e-4be5-a1a6-0095195222f1"
