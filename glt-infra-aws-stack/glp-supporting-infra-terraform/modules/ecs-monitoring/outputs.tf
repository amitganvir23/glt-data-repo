/* We use this to track dependecies between each modules */
output "dependency_id" {
  value = "${null_resource.module_dependency.id}"
}

output "monitoring-cluster-sg-id" {
   value = "${aws_security_group.monitoring-cluster-sg.id}"
}

output "asg-name" {
   value = "${aws_autoscaling_group.ecs-monitoring-cluster.name}"
}

// This is used in userdata
output "ecs_cluster_name" {
   value = "${aws_ecs_cluster.monitoring-cluster.name}"
}
