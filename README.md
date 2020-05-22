# equifax_exercise
Assuming AWS CLI with credentaials are already setup on a machine


# Clone the Terraform Code and create this key before executing the Scripts
touch keys && ssh-keygen -b 2048 -f ./keys/region-nyc

terraform init

terraform plan

terraform apply

wget <Load Balancer DNS Name>.amazonaws.com

terraform destroy

# wget the Load Balancer DNS name from State File
for example:

# Note : Didnt get time to write an SH script to automate the 



