# Coding Exercise

## Objectives

### Online

1. Lock the AWS provider to only allow 3.x (not 4.x).
1. Ensure all resources have a tag named ChargeCode applied with the value
   "04NSOC.SUPP.0000.NSV".
1. Ensure resources are spred across three availability zones.
1. Resolve errors in playbook execution.
1. Format all code per Hashicorp conventions.

### Self-guided

1. Add private subnets with a NAT gateway in three availability zones.
1. Deploy EC2 instances (Amazon Linux 2 AMI, t2.micro, EBS encryption enabled on
   gp3 volumes) in each availability zone in the private subnets.  Ensure a web
   server is deployed on each automatically.
1. Enable each instance for Systems Manager (SSM) agent integration.
1. Deploy an internet facing ALB with an HTTP listener targeting port 80 on each
   of the EC2 instances.
