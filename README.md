# IAC_exercise
Assuming AWS CLI with credentaials are already setup on a machine

This assignment can be done for cloud environments - AWS or GCP using Terraform only. Please share the terraform script created via email/GitHub.
NOTE: Store the terraform state in S3 or GCS bucket
Create a VPC Network (10.X.X.X/21 CIDR) with the following sub component in us- east1. (For AWS create a private subnet and public subnet)
1. Open Firewall ports on (Port 22 /ssh, Port 80/web)
2. Create a bastion host that have access to port 22
3. Create an Auto scaling group with one server(EC2 or VM ) with a launcher
configurations to install web server (example nginx or httpd ) as part install metadata
scripts stored in S3 or GCS
4. Create an application load balancer or Cloud Load balancer to access above
webserver
5. Test the Web URL (Automated) for success/failure check.
6. Destroy the environment.


# Clone the Terraform Code and create this key before executing the Scripts
touch keys
ssh-keygen -b 2048 -f ./keys/region-nyc

touch keys && ssh-keygen -b 2048 -f ./keys/region-nyc

terraform init

terraform plan


(There is a provider error which am seeing Error: Provider produced inconsistent final plan

Below Git Hub Link for the issue reported as am using the latest terraform version,
https://github.com/terraform-providers/terraform-provider-aws/issues/11639

When expanding the plan for aws_autoscaling_group.web_asg to include new
values learned so far during apply, provider "registry.terraform.io/-/aws"
produced an invalid new value for .availability_zones: was known, but now
unknown.

This is a bug in the provider, which should be reported in the provider's own
issue tracker.)

terraform apply

dns_name=$(terraform output instance_dns_name)

curl -s -o /dev/null -w "%{http_code}" $dns_name

terraform destroy

#   Automate the using SH script

chmod +x ./automate.sh

./automate.sh



