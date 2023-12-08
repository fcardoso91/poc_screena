resource "aws_vpc_endpoint" "ec2" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.region.ec2"
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.region.ec2messages"
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.region.ssm"
}

resource "aws_iam_policy" "session_manager_policy" {
  name        = "session_manager_policy"
  path        = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:CreateSession",
          "ssm:StartSession",
          "ssm:TerminateSession",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

data "aws_iam_policy_document" "session_manager_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [
        "com.amazonaws.region.ec2",
        "com.amazonaws.region.ec2messages",
        "com.amazonaws.region.ssm"
      ]
    }
  }
}

resource "aws_iam_role" "session_manager_role" {
  name = "session_manager_role"
  assume_role_policy = data.aws_iam_policy_document.session_manager_policy_document.json
}

resource "aws_iam_policy_attachment" "session_manager_policy_attachment" {
  name = "session_manager_role_attachment_to_session_manager_policy"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  roles      = [aws_iam_role.session_manager_role.name]
}

resource "aws_ssm_document" "poc_screena" {
  name            = "test_document"
  document_format = "YAML"
  document_type   = "Command"

  content = <<DOC
schemaVersion: '1.2'
description: Check ip configuration of a Linux instance.
parameters: {}
runtimeConfig:
  'aws:runShellScript':
    properties:
      - id: '0.aws:runShellScript'
        runCommand:
          - ifconfig
          - psql
          - ssh
          - ls
          - cd
          - cat
          - ip
          - nslookup
          - more
          - less
DOC
}

#<generical_object_type> <resource_type> (issu de l'API du cloud provider - AWS) <resource_name>(for terraform)
# resource "aws_ssm_association" "poc_screena" {
#   name = aws_ssm_document.poc_screena.name
  
#   targets {
#     key    = "InstanceIds"
#     values = [aws_instance.poc_screena.id]
#   }
# }
