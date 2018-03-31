import time
from subprocess import Popen, PIPE, STDOUT

def lambda_handler(event, context):
    cmd = '/var/task/customruby/bin/inspec version'
    p = Popen(cmd, shell=True, stdin=PIPE, stdout=PIPE, stderr=STDOUT, close_fds=True)
    output = p.stdout.read()
    print(output.decode('utf-8'))
    return

if __name__ == '__main__':
    lambda_handler('event', 'handler')
