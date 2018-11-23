/* We use this to track dependencies between each modules */
output "dependency_id" {
  value = "${null_resource.module_dependency.id}"
}

output "monitoring-external-elb-name" {
   value = "${aws_elb.monitoring-external-elb.name}"
}

output "monitoring-external-elb-zone-id" {
   value = "${aws_elb.monitoring-external-elb.zone_id}"
}

output "monitoring-external-elb-dns-name" {
   value = "${aws_elb.monitoring-external-elb.dns_name}"
}
