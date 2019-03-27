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

