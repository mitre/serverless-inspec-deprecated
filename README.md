# serverless-inspec

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

