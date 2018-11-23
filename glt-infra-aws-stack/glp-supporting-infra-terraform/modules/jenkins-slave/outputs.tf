output "jenkins-slave-sg" {
   value = "${aws_security_group.jenkins-slave-sg.id}"
}

output "jenkins-slave-ip" {
  value = "${aws_instance.jenkins-slave.private_ip}"
}
