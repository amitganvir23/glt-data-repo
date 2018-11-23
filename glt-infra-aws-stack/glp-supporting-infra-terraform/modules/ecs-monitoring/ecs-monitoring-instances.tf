/*
  Application clusters
  This is where all backend applications will be launched via
  ecs tasks
*/


/* This is used to generate data about ami to be used */
data "aws_ami" "ecs-monitoring" {
  most_recent = true

  filter {
    name   = "owner-id"
    values = ["${var.ami_owner_name}"]
  }

  filter {
    name   = "name"
    values = ["${var.ami_name_regex}"]
  }

}


resource "aws_launch_configuration" "ecs-monitoring-cluster" {
  image_id                    = "${data.aws_ami.ecs-monitoring.id}"
  name_prefix                 = "ecs-monitoring-cluster-${var.environment}-"
  instance_type               = "${var.monitoringcluster_instance_type}"
  associate_public_ip_address = true
  key_name                    = "${var.aws_key_name}"
  security_groups             = ["${aws_security_group.monitoring-cluster-sg.id}"]
  user_data                   = "${data.template_file.userdata-monitoring-cluster.rendered}"
  iam_instance_profile        = "${aws_iam_instance_profile.ecs_profile_monitoring.name}"
  placement_tenancy           = "default"

  root_block_device {
    volume_type           = "standard"
    volume_size           = 30
    delete_on_termination = true
  }

  connection {
    user  = "ec2-user"
    agent = true
  }


  // We have to set this to true to avoid error
  // ResourceInUse: Cannot delete launch configuration
  // {lc_name} because it is attached to AutoScalingGroup ECS-APPLICATION-CLUSTER-Demo
  lifecycle {
    create_before_destroy = true
  }

 #depends_on = ["aws_ecs_cluster.app-cluster"]

}


resource "aws_autoscaling_group" "ecs-monitoring-cluster" {
  # Scheduling implemented for this asg
  vpc_zone_identifier       = ["${var.private_subnet_ids}"]
  name                      = "ECS-MONITORING-CLUSTER-${var.environment}"
  max_size                  = "${var.ecs_monitoring_asg_max_size}"
  min_size                  = "${var.ecs_monitoring_asg_min_size}"
  health_check_grace_period = 100
  health_check_type         = "EC2"
  load_balancers            = ["${var.load_balancers}"]
  desired_capacity          = "${var.ecs_monitoring_asg_desired_size}"
  force_delete              = false
  launch_configuration      = "${aws_launch_configuration.ecs-monitoring-cluster.name}"

 // Setting this to true would not allow us to delete the ECS clusters
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "ECS-MONITORING-INSTANCES"
    propagate_at_launch = true
  }

  tag {
      key                 = "Environment"
      value               = "${var.environment}"
      propagate_at_launch = true
  }

  // This will decide Ansible role to be applied via dynamic inventory
  tag {
    key                 = "Role"
    value               = "monitoring-instances"
    propagate_at_launch = true
  }

  tag{
    key                 = "Stack"
    value               = "Infra-GLT"
    propagate_at_launch = true
  }


  tag{
    key                 = "weave:peerGroupName"
    value               = "GLT-${var.environment}"
    propagate_at_launch = true
  }

  depends_on = ["aws_launch_configuration.ecs-monitoring-cluster"]
}

resource "aws_ecs_cluster" "monitoring-cluster" {
  name = "Monitoring-Cluster-${var.environment}"

  lifecycle {
    create_before_destroy = true
  }
}

/* We use this to create this as a dependency for other modules */
resource "null_resource" "module_dependency" {
  depends_on = ["aws_autoscaling_group.ecs-monitoring-cluster"]
}
