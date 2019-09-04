# devops-hptik
To hold the answers of the Haptik Devops Assignment

# This will install the below on AWS 
1. vpc
2. subnets - one public, two private
3. route tables
4. ec2 instance red hat 
5. provisoner to install the required packages
6. rds mysql server with username and password from the tf file


Once the above has been executed terraform will output the below parameters:

1. ec2 instance public IP Address
2. rds instance addrress
3. ec2 instance public dns


# Set below parameters using command line

export AWS_ACCESS_KEY_ID=""  <br />
export AWS_SECRET_ACCESS_KEY=""  <br />
export AWS_DEFAULT_REGION=""  <br />

```bash
terraform init
```

```bash
terraform plan
```

```bash
terraform apply
```