#!/bin/bash

INSPECBUCKET=$1
OUTPUTBUCKET=$2

# Validate the cloudformation template
aws cloudformation validate-template --template-body file://cf-serverless-inspec.json

# Deploy cloudformation stack
aws cloudformation deploy --template-file cf-serverless-inspec.json --stack-name serverless-inspec --parameter-overrides S3BucketName=$INSPECBUCKET InSpecOutputBucket=$OUTPUTBUCKET --capabilities CAPABILITY_NAMED_IAM

# Test Lambda Function
aws lambda invoke --function-name InSpecLambda --invocation-type RequestResponse --log-type Tail --payload '{}' outfile.txt

# Upload lambda function to S3
aws s3 cp lambda.zip s3://$INSPECBUCKET
