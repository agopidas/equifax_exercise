# Initialise the configuration
#terraform init -input=false
# Plan and deploy
#terraform plan -input=false -out=tfplan
#terraform apply tfplan

#terraform apply tfplan

dns_name=$(terraform output instance_dns_name)

function test {
    res=`curl -s -I $1 | grep HTTP/1.1 | awk {'print $2'}`
    if [ $res -ne 200 ]
    then
        echo "Error $res on $1"
    fi
}

test $dns_name

# Find your results in the Terraform output

# Once finished, destroy the server
#terraform plan -destroy -out=tfdestroy
#terraform apply tfdestroy