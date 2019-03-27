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

```bash
sls deploy
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
| **Author:**    | Martez Reed (<martez.reed@greenreedtech.com)     |
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
