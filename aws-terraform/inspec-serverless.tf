provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default.id}"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name = "name"

    values = [
      "amzn2-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}

## InSpec builder
resource "aws_iam_instance_profile" "inspec-serverless" {
  name = "inspec-serverless-instance-profile"
  role = "${aws_iam_role.inspec-serverless.name}"
}

resource "aws_iam_role" "inspec-serverless" {
  name               = "inspec-serverless-role"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

resource "aws_iam_role_policy" "inspec-serverless" {
  name   = "inspec-serverless-role-policy"
  role   = "${aws_iam_role.inspec-serverless.id}"
  policy = "${data.aws_iam_policy_document.inspec-serverless.json}"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "inspec-serverless" {

  statement {
    sid    = "LambdaAccess"
    effect = "Allow"
    actions = [
      "lambda:*"
    ],
    resources = ["*"]
  }

  statement {
    sid    = "LogGroupAccess"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:DeleteLogGroup",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:FilterLogEvents",
      "logs:GetLogEvents"
    ]

    resources = ["*"]
  }
}

module "inspec-serverless" {
  source = "terraform-aws-modules/ec2-instance/aws"
  instance_count = 1

  name                          = "inspec-serverless"
  ami                           = "${data.aws_ami.amazon_linux.id}"
  associate_public_ip_address   = true
  instance_type                 = "t2.micro"
  iam_instance_profile          = "${aws_iam_instance_profile.inspec-serverless.id}"
  key_name                      = "InSpecDemo"
  subnet_id                     = "subnet-0ff30a4580c4df74a"
  vpc_security_group_ids        = ["sg-0a61bb03e71dcbaed"]
  user_data                     = "${file("inspec-serverless.sh")}"

  tags {
        Owner       = "GRT"
        Environment = "dev"
        DeployFrom  = "terraform"
  }
}
