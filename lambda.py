import time
import os
import json
from subprocess import Popen, PIPE, STDOUT
import boto3

def get_account_id():
    """
    Retrieve the AWS account ID
    """
    client = boto3.client("sts")
    account_id = client.get_caller_identity()["Account"]
    return account_id

def generate_json(service_type,output):
    """
    Generate the JSON filename
    """
    filename = 'inspec-' + service_type + '-' + time.strftime("%Y%m%d-%H%M%S") + '.json'
    outputfile = '/tmp/' + filename
    f = open(outputfile,"w")
    f.write(output)
    return filename,outputfile

def lambda_handler(event, context):
    github_repo = os.environ['GITHUB_REPO']

    # Specify region to scan
    if os.environ['INSPEC_AWS_REGION']:
        aws_region = os.environ['INSPEC_AWS_REGION']
    else:
        aws_region = os.environ['AWS_REGION']

    # Check if S3 bucket is specified
    if os.environ['S3_BUCKET']:
        s3_bucket = os.environ['S3_BUCKET']
    else:
        s3_bucket = null

    cmd = '/var/task/customruby/bin/inspec exec --reporter cli json:/tmp/inspec_output.json --no-color ' + github_repo + ' -t aws://' + aws_region
    p = Popen(cmd, shell=True, stdin=PIPE, stdout=PIPE, stderr=STDOUT, close_fds=True)
    output = p.stdout.read()
    print(output.decode('utf-8'))


    """
    Create JSON File
    """
    data = json.load(open('/tmp/inspec_output.json'))
    data = json.dumps(data)
    account_id = get_account_id()
    filename,outputfile = generate_json('aws',data)

    """
    Upload InSpec output to S3 Bucket
    """

    s3 = boto3.client('s3')
    s3.upload_file(outputfile, s3_bucket, filename)

    return

if __name__ == '__main__':
    lambda_handler('event', 'handler')
