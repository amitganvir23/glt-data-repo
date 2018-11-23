/*
This module will generate config for our ansible playbooks
We need to pass env, region and cluster name for all applications to
our ansible roles.
Two provisioners to be used
- create time ( deploy all services )
- destroy time ( delete all ecs cluster else tf wont be able to destroy completely )
*/


data "template_file" "ansible_ecs_deploy" {
     template   = "${file("${path.module}/templates/ansible_ecs_deploy.sh")}"

     vars {
       env                          = "${lower(var.env)}"
       region                       = "${var.region}"
       route53_domain               = "${var.route53_domain}"
       route53_private_domain       = "${var.route53_private_domain}"
     }

}

data "template_file" "ansible_ecs_destroy" {
     template   = "${file("${path.module}/templates/ansible_ecs_destroy.sh")}"

     vars {
       env                          = "${lower(var.env)}"
       region                       = "${var.region}"
       route53_domain               = "${var.route53_domain}"
       route53_private_domain       = "${var.route53_private_domain}"
     }

}


resource "null_resource" "ansible_ecs_generate" {

   triggers {
      # This will trigger create on every run
      filename = "test-${uuid()}"
   }

   provisioner "local-exec" {
      command = "echo '${ data.template_file.ansible_ecs_deploy.rendered }' > ../../glt-ansible-code/ansible_call_deploy.sh"
   }

   provisioner "local-exec" {
      command = "chmod 755 ../../glt-ansible-code/ansible_call_deploy.sh"
   }

   provisioner "local-exec" {
      command = "../../glt-ansible-code/ansible_call_deploy.sh"
   }

}

/***********************************************
- Disabling destroy provisioner.
- Enable this when we want to try destruction
****/
/*
resource "null_resource" "ansible_ecs_destroy" {

   triggers {
      template_rendered = "${data.template_file.ansible_ecs_destroy.rendered}"
      when    = "destroy"

   }

   provisioner "local-exec" {
      command = "echo '${ data.template_file.ansible_ecs_destroy.rendered }' > ../../glt-ansible-code/ansible_call_destroy.sh"
      when    = "destroy"

   }

   provisioner "local-exec" {
      command = "chmod 755 ../../glt-ansible-code/ansible_call_destroy.sh"
      when    = "destroy"

   }

   provisioner "local-exec" {
      command = "../../glt-ansible-code/ansible_call_destroy.sh"
      when    = "destroy"
   }

}
*/
/*************************************************/
