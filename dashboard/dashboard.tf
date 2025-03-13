resource "aws_cloudwatch_dashboard" "wsi_api" {
  dashboard_name = "WSI_API"

  dashboard_body = jsonencode({
    widgets = [
      {
        "type": "metric",
        "x": 0,
        "y": 0,
        "width": 6,
        "height": 6,
        "properties": {
          "region": "ap-northeast-2",
          "metrics": [
            ["AWS/ApplicationELB", "HTTPCode_ELB_5XX_Count", "LoadBalancer", "${var.alb_arn}", { "stat": "Sum" }]
          ],
          "title": "HTTP_ERROR",
          "view": "timeSeries",
          "stacked": false
        }
      },
      {
        "type": "metric",
        "x": 6,
        "y": 0,
        "width": 6,
        "height": 6,
        "properties": {
          "region": "ap-northeast-2",
          "metrics": [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", "${var.alb_arn}", { "stat": "Sum" }]
          ],
          "title": "HTTP_COUNT",
          "view": "timeSeries",
          "stacked": false
        }
      },
      {
        "type": "metric",
        "x": 0,
        "y": 6,
        "width": 6,
        "height": 6,
        "properties": {
          "region": "ap-northeast-2",
          "metrics": [
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", "${var.alb_arn}", { "stat": "Average" }]
          ],
          "title": "RESPONSE_TIME",
          "view": "timeSeries",
          "stacked": false
        }
      },
      {
        "type": "metric",
        "x": 6,
        "y": 6,
        "width": 6,
        "height": 6,
        "properties": {
          "region": "ap-northeast-2",
          "metrics": [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "wsi-web-api-asg", { "stat": "Average" }]
          ],
          "title": "API_CPU",
          "view": "timeSeries",
          "stacked": false
        }
      }
    ]
  })
}
