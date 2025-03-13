resource "aws_iam_role" "web_api_role" {
  name = "${var.prefix}-web-api-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_readonly_policy_attachment" {
  role       = aws_iam_role.web_api_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "cw_agent_server_policy_attachment" {
  role       = aws_iam_role.web_api_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "bastion_instance_profile" {
  name = "${var.prefix}-web-api-profile"
  role = aws_iam_role.web_api_role.name
}

