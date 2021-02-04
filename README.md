# Terraform

All the projects in this directory are built the same way - common terraform scripts that are used for each of the environments. Parameter files are specific for the environment. S3 buckets in each AWS account are used to store terraform state. The dynamo tables allows 2 people to safely work on the same project in the same environment at the same time.

## Environment setup
Currently prod, qa and dev AWS account already have terrafom buckets and dynamo tables setup. However if you ever need to do setup in another AWS account run the following commands

### Setup the variables
```shell
export ENV="<env example dev>"
export AWS_REGION="<aws-region example us-east-1>

```
### Setup S3 bucket to hold terraform state

```shell
BUCKET_NAME="ngc-${ENV}-terraform-state"

# Create the bucket
aws --region "$AWS_REGION" s3api create-bucket --bucket "$BUCKET_NAME" \
    --acl private --create-bucket-configuration LocationConstraint="$AWS_REGION"

# Enable versioning
aws --region "$AWS_REGION" s3api put-bucket-versioning --bucket "$BUCKET_NAME" \
    --versioning-configuration Status=Enabled

```

### Create a DynamoDB table for terraform state-locking

```shell
DYNAMODB_TABLE_NAME="ngc-terraform-${ENV}"

aws  --region "$AWS_REGION" dynamodb create-table --table-name "$DYNAMODB_TABLE_NAME" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1
```

In the current setup when terraform runs it is going to acquire a lock for the environment it runs against. Which means 2 users would not be able to work with the same env at the same time. We can create lock tables per project if we ever need more granularity.

## Starting with the new terraform project

### Setup the variables
```shell
export AWS_REGION="<aws-region example us-east-1>"

```
### Create the project directory 

Call script to setup initial project framework. Script is going to create setup for 3 environments (dev, qa, prod)- feel free to only keep environments that you need.

```
scripts/tf-initial-setup "${PROJECT}"
```

### Run terraform script in the environment

```
cd ${PROJECT}/environment/dev
terraform fmt
terraform init
terraform apply
```

Output should look similar to ![this](terraform_run.jpg?raw=true "Run on Ubunu bionic")

## Additional information
After initial setup is created you are going to have the basic files in the each project environment. Keep in mind that names of the files does not really matter - they all get joined together when terrafrm runs. So going forward you can add more information to existing files or write new files in the same directory that can be called anything not necesseraly main.tf, outputs.tf and variables.tf. Extension has to be `tf`. 

Some environments have dedicated file for a piece of the infra like [the script to create data warehouse for caseconnect project](tf-caseconnect/datawarehouse.tf). This script has everything joined together - and it is only linked in production directory since datawarehouse is only created for production. I could have broken it into 3 files or in as many files as I want as long as they had extenion `tf`.

Caseconnect has environments named `cconnect-prod` `cconnect-qa` and `cconnect-dev` that all are setup to run in production AWS account.


