# serverless-inspec

[![GitHub release](https://img.shields.io/github/release/martezr/serverless-inspec.svg)](https://github.com/martezr/serverless-inspec/releases)
[![Travis branch](https://img.shields.io/travis/martezr/serverless-inspec/master.svg)](https://travis-ci.org/martezr/serverless-inspec)
[![license](https://img.shields.io/github/license/martezr/serverless-inspec.svg)](https://github.com/martezr/serverless-inspec/blob/master/LICENSE.txt)

An Amazon Web Services (AWS) Lambda function for running Chef InSpec in a serverless fashion

# Getting Started

Clone the github repository

```bash
git clone https://github.com/martezr/serverless-inspec.git
```

Change directory to serverless-inspec

```bash
cd serverless-inspec
```

Provision the AWS EC2 instance

```bash
cd aws-terraform
```

```bash
terraform init
```

```bash
terraform apply --auto-approve
```

SSH to the EC2 instance and run sls deploy

```bash
cd /serverless-inspec/code
```

### Serverless Deployment File

The Lambda function is deployed using the Serverless framework (https://serverless.com) to simplify the packaging and deployment. Included in the repository is the code/serverless.yaml deployment file that can be used and modifications can be made by referencing the Serverless documentation (https://serverless.com/framework/docs/providers/aws/guide/serverless.yml/).

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
[root@ip-172-31-2-252 code]# sls deploy
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
