#!/bin/bash

# Invoke Lambda Function
aws lambda invoke --function-name InSpecLambda --invocation-type RequestResponse --log-type Tail --payload '{}' outfile.txt
