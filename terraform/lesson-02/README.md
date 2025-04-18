# Terraform Distributed State: Reducing the Blast Radius and Segmenting Infrastructure Management

## Forward

- Thank you for taking the time to start reading this educational material.
- I hope this hands-on, interactive lesson can reduce the startup \
  cost in your journey to learning how to better manage large AWS \
  infrastructure projects using [Terraform](https://www.terraform.io).

## Overview

- In this lesson we will be creating the following components in an AWS Account:
  - A Virtual Private Cloud (VPC)
  - An Elastic Container Registry (ECR) Repository
- Each component is tracked via its own Terraform State file, stored in AWS S3

## Preflight

* Set your account's Terraform state bucket
```shell
export TF_STATE_BUCKET=$(echo -n "Enter in value for the terraform state bucket: " >/dev/null;read -s value;echo $value)
```
* Create Terraform state s3 buckets
```shell
aws s3api create-bucket --bucket "${TF_STATE_BUCKET}"
```
* Enable s3 bucket versioning for the newly-created bucket
```shell
aws s3api put-bucket-versioning \
--bucket "${TF_STATE_BUCKET}" \
--versioning-configuration Status=Enabled
```

## Lesson

### Create the VPC

* Change working directory to the vpc module
  ```shell
  cd vpc
  ```
* Run a terraform init
  ```shell
  terraform init \
  -backend-config="bucket="${TF_STATE_BUCKET}"" \
  -backend-config="region=us-east-1" \
  -backend-config="key=us-east-1/vpc/terraform.tfstate"
  ```
* Run a terraform plan
  ```shell
  terraform plan -var aws_account_id=$(aws sts get-caller-identity | jq -r '. | .Account')
  ```
* Run a terraform apply
  ```shell
  terraform apply -var aws_account_id=$(aws sts get-caller-identity | jq -r '. | .Account')
  ```

#### Validations

* Verify that the vpc has been created
```shell
aws ec2 describe-vpcs --filters Name=tag:Name,Values=dev-lesson-02  --query "Vpcs[].Tags[?Key=='Name'].Value[]" | jq -r '.[]'
```

### Create the ECR repo

* Switch back to the repository root & change working directory to the ecr module
  ```shell
  cd ..
  cd ecr
  ```
* Run a terraform init
  ```shell
  terraform init \
  -backend-config="bucket="${TF_STATE_BUCKET}"" \
  -backend-config="region=us-east-1" \
  -backend-config="key=us-east-1/ecr/terraform.tfstate"
  ```
* Run a terraform plan
  ```shell
  terraform plan -var terraform_state_bucket="${TF_STATE_BUCKET}"
  ```
* Run a terraform apply
  ```shell
  terraform apply -var terraform_state_bucket="${TF_STATE_BUCKET}"
  ```

#### Validations

* Verify that the ecr repo has been created
```shell
aws ecr describe-repositories | jq '.repositories[] | select('.repositoryName' == "dev/busybox") | .repositoryUri'
```

### Cleanup

* Run terraform destroy for ec
```shell
cd ..
cd ecr
terraform destroy -var terraform_state_bucket="${TF_STATE_BUCKET}"
```
* Run terraform destroy for ec
```shell
cd ..
cd vpc
terraform destroy -var aws_account_id=$(aws sts get-caller-identity | jq -r '. | .Account')
```