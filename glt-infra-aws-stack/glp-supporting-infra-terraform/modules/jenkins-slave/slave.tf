resource "aws_instance" "jenkins-slave" {
    ami                         = "${var.jenkins-slave-ami}"
    instance_type               = "${var.jenkins_slave_instance_type}"
    key_name                    = "${var.aws_key_name}"
    vpc_security_group_ids      = ["${aws_security_group.jenkins-slave-sg.id}"]
    #count                      = "${length(var.public_sub_cidr)}"
    #user_data                  = "${data.template_file.userdata-jenkins.rendered}"
    subnet_id                   = "${var.pub_sub_id}"
    associate_public_ip_address = true
    source_dest_check           = false
    // Implicit dependency
    iam_instance_profile        = "${aws_iam_instance_profile.jenkins_slave_profile.name}"

    tags = {
      Name        = "ECS-Jenkins-Slave"
      Role        = "jenkins"
      Environment = "${var.environment}"
      Stack       = "Supporting-GLT"
    }

}
