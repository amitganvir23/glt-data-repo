# Terraform and Ansible scripts for GLT provisioing

  - Terraform to deploy Supporting Infra AWS stack 
  - Ansible roles for configuring Infra GLT AWS Stack

##### Dependencies

  - Terraform > 0.9
  - AWS keys exported as env variables
  - Ansible.cfg should exist
  - Dynamic inventory setup
  - Boto
  - Boto3
  - Python > 2.7
  - Ansible. 
  
# Put your Jenkins Private key content in below file path for each branch
  - glt-infra-supporting-aws-stack/glt-ansible-code/playbooks/roles/jenkins_slave/files/jenkins_id_rsa
