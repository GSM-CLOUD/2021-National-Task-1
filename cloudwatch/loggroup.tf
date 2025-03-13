resource "aws_cloudwatch_log_group" "log_group" {
  name = "/aws/ec2/${var.prefix}"

  tags = {
    "Name" = "/aws/ec2/${var.prefix}"
  }
}