resource "aws_instance" "jenkins-master" {
    ami                         = "${var.jenkins-master-ami}"
    instance_type               = "${var.jenkins_master_instance_type}"
    key_name                    = "${var.aws_key_name}"
    vpc_security_group_ids      = ["${aws_security_group.jenkins-master-sg.id}"]
    #count                      = "${length(var.public_sub_cidr)}"
    #user_data                  = "${data.template_file.userdata-jenkins.rendered}"
    subnet_id                   = "${var.pub_sub_id}"
    associate_public_ip_address = true
    source_dest_check           = false
    // Implicit dependency
    iam_instance_profile        = "${aws_iam_instance_profile.jenkins_profile.name}"

    tags = {
      Name        = "ECS-Jenkins-Master"
      Role        = "jenkins"
      Environment = "${var.environment}"
      Stack       = "Supporting-GLT"
    }

}

#resource "null_resource" "jenkins-slave" {

#provisioner "local-exec" {
#      command = "sleep 4m && ansible-playbook ../../ansible-code/jenkins-node/jenkins-slave.yml --private-key=/root/terra-amit-key -i /etc/ansible/ec2.py -e slave_ip=${var.slave_ip} "
#}

#}
