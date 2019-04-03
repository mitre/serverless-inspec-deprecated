# serverless-inspec

[![GitHub release](https://img.shields.io/github/release/martezr/serverless-inspec.svg)](https://github.com/martezr/serverless-inspec/releases)
[![Travis branch](https://img.shields.io/travis/martezr/serverless-inspec/master.svg)](https://travis-ci.org/martezr/serverless-inspec)
[![license](https://img.shields.io/github/license/martezr/serverless-inspec.svg)](https://github.com/martezr/serverless-inspec/blob/master/LICENSE.txt)

An Amazon Web Services (AWS) Lambda function for running Chef InSpec in a serverless fashion

# Getting Started

The following steps walk through how to deploy the "builder" AWS EC2 instance (optional) and deploy the serverless inspec Lambda function.

Clone the github repository

```bash
git clone https://github.com/martezr/serverless-inspec.git
```

Change directory to serverless-inspec

```bash
cd serverless-inspec
```


## Provision Build AWS EC2 Instance

The code in this repository uses the serverless framework to deploy the Lambda function and Lambda layer. An AWS EC2 instance is used to act as a deployment server and has the serverless CLI installed along with Docker.

** Requires Terraform to be installed **

Change directory into the `aws-terraform` directory where the Terraform code is located.

```bash
cd aws-terraform
```

Run the `terraform init` command to download the appropriate Terraform providers. The scaffold code uses local storage for storing the Terraform state file.

```bash
terraform init
```
### Terraform Input Variables

The Terraform code supports the following input variables. The variables can be supplied on the command line as individual arguments or added to a variables file similar to the `grt-dev.tfvars` file in the repo.

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| region | The AWS region to depoy to | string | `us-east-1` | no |
| instance_type | The type of instance to start | string | `t2.micro` | no |
| key_name | The key name to use for the instance | string | `-` | yes |
| subnet_id | The VPC Subnet ID to launch in | string | `-` | yes |
| vpc_security_group_ids | A list of security group IDs to associate with | list | `-` | no |


Run the `terraform apply` command with the `--auto-approve` flag to prevent being prompted for confirmation along with the name of the Terraform variables file.

```bash
terraform apply --auto-approve -var-file=grt-dev.tfvars
```

SSH to the EC2 instance and change the directory to the code directory in the serverless-inspec git repo on the EC2 instance.

```bash
cd /serverless-inspec/code
```

### Serverless Deployment File

The Lambda function is deployed using the Serverless framework (https://serverless.com) to simplify the packaging and deployment. Included in the repository is the code/serverless.yaml deployment file that can be used and modifications can be made by referencing the Serverless documentation (https://serverless.com/framework/docs/providers/aws/guide/serverless.yml/).

The `sls deploy` command is used to deploy the Lambda function and the name of the S3 bucket to store the scan results along with the URL of the InSpec profile to run should be provided as command line arguments.

```bash
service: inspec-serverless

provider:
  name: aws
  runtime: ruby2.5
  region: us-east-1
  stage: prod
  iamManagedPolicies:
    - 'arn:aws:iam::aws:policy/ReadOnlyAccess'
  environment:
    HOME: /tmp
    INSPEC_PROFILE: "https://github.com/martezr/serverless-inspec-profile"
    S3_DATA_BUCKET: mreed-bucket

functions:
  inspec_scan:
    handler: handler.inspec_scan
    layers:
      - {Ref: InspecLambdaLayer }

layers:
  inspec:
    path: layer
```

### Deploying the Lambda function

The Lambda function can be deployed using the provided serverless deployment file by running the following command from the "code" directory in the repository.

```bash
[root@ip-172-31-2-252 code]# sls deploy --s3_data_bucket mreed-bucket --inspec_profile https://github.com/martezr/serverless-inspec-profile
Serverless: Packaging service...
Serverless: Excluding development dependencies...
Serverless: Excluding development dependencies...
Serverless: Creating Stack...
Serverless: Checking Stack create progress...
.....
Serverless: Stack create finished...
Serverless: Uploading CloudFormation file to S3...
Serverless: Uploading artifacts...
Serverless: Uploading service inspec-serverless.zip file to S3 (372 B)...
Serverless: Uploading service inspec.zip file to S3 (37.66 MB)...
Serverless: Validating template...
Serverless: Updating Stack...
Serverless: Checking Stack update progress...
..................
Serverless: Stack update finished...
Service Information
service: inspec-serverless
stage: prod
region: us-east-1
stack: inspec-serverless-prod
resources: 6
api keys:
  None
endpoints:
  None
functions:
  inspec_scan: inspec-serverless-prod-inspec_scan
layers:
  inspec: arn:aws:lambda:us-east-1:684882843674:layer:inspec:7
```

## Environment Variables

The following environment variables are defined for the Lambda function.

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| HOME | The HOME environment variable for enabling proper execution of the Lambda function | string | `/tmp` | yes |
| INSPEC_PROFILE | The github url of the InSpec profile to run | string | `-` | yes |
| S3_DATA_BUCKET | The name of the Amazon Web Services (AWS) S3 bucket to store the JSON output file | string | `-` | no |

## Destroy the "Builder" AWS EC2 Instance

Once the Lambda function has been deployed the "builder" AWS EC2 instance can be destroyed.

Run the `terraform destroy` command with the `--auto-approve` flag to prevent being prompted for confirmation along with the name of the Terraform variables file.

```bash
terraform destroy --auto-approve -var-file=grt-dev.tfvars
```


## License

|                |                                                  |
| -------------- | ------------------------------------------------ |
| **Author:**    | Martez Reed (<martez.reed@greenreedtech.com>)    |
| **Copyright:** | Copyright (c) 2018-2019 Green Reed Technology    |
| **License:**   | Apache License, Version 2.0                      |

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
