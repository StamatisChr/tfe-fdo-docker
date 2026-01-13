# install-TFE-with-docker

## What is this guide about?

This guide is to have Terraform Enterprise running with Docker.

## Prerequisites 

- Account on AWS Cloud

- AWS IAM user with permissions to use AWS EC2 and AWS Route53

- SSH key pair on AWS 

- A DNS zone hosted on AWS Route53

- Terraform Enterprise Docker license

- Git installed and configured on your computer

- Terraform installed on your computer

## Create the AWS resources and start TFE

Export your AWS access key and secret access key as environment variables:
```
export AWS_ACCESS_KEY_ID=<your_access_key_id>
```

```
export AWS_SECRET_ACCESS_KEY=<your_secret_key>
```


Clone the repository to your computer.

Open your cli and run:
```
git@github.com:StamatisChr/TFE-FDO-docker.git
```


When the repository cloning is finished, change directory to the repo’s terraform directory:
```
cd TFE-FDO-docker
```

Here you need to create a `variables.auto.tfvars` file with your specifications. Use the example tfvars file.

Rename the example file:
```
cp variables.auto.tfvars.example variables.auto.tfvars
```
Edit the file:
```
vim variables.auto.tfvars
```

```
# example tfvars file
# do not change the variable names on the left column
# replace only the values in the "< >" placeholders

aws_region                    = "<aws_region>"            # Set here your desired AWS region, example: eu-west-1
tfe_instance_type             = "<aws_ec2_instance_type>" # Set here the EC2 instance type only architecture x86_64 is supported, example: m5.xlarge
my_key_name                   = "<aws_ssh_key_name>"      # the AWS SSH key name  (region specific, it should exist in the same AWS region as the one set above)
hosted_zone_name              = "<dns_zone_name>"         # your AWS route53 DNS zone name
tfe_dns_record                = "<tfe_host_record>"       # the host record for your TFE instance on your dns zone, example: my-tfe
tfe_license                   = "<tfe_license_string>"    # TFE license string
tfe_encryption_password       = "<type_a_password>"       # TFE encryption paasowrd
tfe_version_image             = "<tfe_version>"           # desired TFE version for podman, example: v202410-1
```


To populate the file according to the file comments and save.

Initialize terraform, run:
```
terraform init
```

Create the resources with terraform, run:
```
terraform apply
```
review the terraform plan.

Type yes when prompted with:
```
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: 
```
Wait until you see the apply completed message and the output values. 

Wait about 7-8 minutes for Terraform Enterprise to initialize.

Use the output values to connect to the Terraform Enterprise web UI.

## Clean up

To delete all the resources, run:
```
terraform destroy
```
type yes when prompted.

Wait for the resource deletion.
```
Destroy complete! Resources: destroyed.
```

Done.