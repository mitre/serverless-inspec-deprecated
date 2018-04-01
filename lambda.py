import time
import os
from subprocess import Popen, PIPE, STDOUT

def lambda_handler(event, context):
    github_repo = os.environ['GITHUB_REPO']

    # Specify region to scan
    if os.environ['INSPEC_AWS_REGION']:
        aws_region = os.environ['INSPEC_AWS_REGION']
    else:
        aws_region = os.environ['AWS_REGION']

    cmd = '/var/task/customruby/bin/inspec exec --no-color ' + github_repo + ' -t aws://' + aws_region
    p = Popen(cmd, shell=True, stdin=PIPE, stdout=PIPE, stderr=STDOUT, close_fds=True)
    output = p.stdout.read()
    print(output.decode('utf-8'))
    return

if __name__ == '__main__':
    lambda_handler('event', 'handler')
