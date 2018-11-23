/* We use this to track dependencies between each modules */
output "dependency_id" {
  value = "${null_resource.module_dependency.id}"
}

output "jenkins-external-elb-name" {
   value = "${aws_elb.jenkins-external-elb.name}"
}

output "jenkins-external-elb-zone-id" {
   value = "${aws_elb.jenkins-external-elb.zone_id}"
}

output "jenkins-external-elb-dns-name" {
   value = "${aws_elb.jenkins-external-elb.dns_name}"
}
