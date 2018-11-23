#!/bin/bash

## Pre-reqs
# - Ansible > 2.0
# - Botocore
# - Boto3
# - python 2. 7

# For Dynamic inventory
export AWS_REGION=${region}
echo $AWS_REGION
# **** Only for localhost***
# **** ALL VM level configuration is done via ansible pull *****#


ansible_code_dir="../../glt-ansible-code"

ansible-playbook -i $ansible_code_dir/hosts/ec2.py $ansible_code_dir/site-ecs-delete.yml --extra-vars \
"env=${env}
region=${region}
route53_domain=${route53_domain}
route53_private_domain=${route53_private_domain}
"
