resource "aws_security_group" "web_api_sg" {
  vpc_id = var.vpc_id
  description = "web-api-sg"
  ingress = [{
    description = "web-api-sg"
    cidr_blocks = []
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = [var.alb_sg_id]
    self = false
  }]

  egress = [{
    description = "web-api-sg"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
  }]


  tags = {
    "Name" = "${var.prefix}-web-api-sg"
  }
}