# serverless-inspec: InSpec running serverless


# Requirements

serverless-inspec requires the following

* Docker installed on the build system

# Getting Started

Clone the github repository

```bash
git clone https://github.com/martezr/serverless-inspec.git
```

Change directory to serverless-inspec

```bash
cd serverless-inspec
```

Build the package

```bash
scripts/build.sh
```

Deploy the cloudformation template
```bash
scripts/deploy.sh $inspec_bucket $output_bucket
```

# Lambda Function

## IAM Permissions



## Supported Environment Variables

* HOME: /tmp
* GITHUB_REPO:
* INSPEC_AWS_REGION:
