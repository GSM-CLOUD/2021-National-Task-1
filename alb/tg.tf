resource "aws_lb_target_group" "web_api_tg" {
    name = "${var.prefix}-web-api-tg"
    port = 8080
    protocol = "HTTP"
    target_type = "instance"
    vpc_id = var.vpc_id

    health_check {
      path = "/health"
      interval = 30
      timeout = 5
      healthy_threshold = 3
      unhealthy_threshold = 3 
    }

    tags = {
      Name = "${var.prefix}-web-api-tg"
    }
}