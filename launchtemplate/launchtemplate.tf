resource "aws_launch_template" "web_api_launch_template" {
  name = "${var.prefix}-launch-template"
  image_id = var.aws_ami
  instance_type = "t3.small"
  key_name = var.key_name
  iam_instance_profile {
    name = aws_iam_instance_profile.web_api_profile.name
  }

  user_data = base64encode(<<EOF
#!/bin/bash
sudo su

echo "complete"
yum install python3 pip -y
pip3 install flask

echo "complete"
aws s3 cp s3://${var.bucket_backend_name}/app.py .

echo "complete"
mkdir -p /var/log/app
chmod 777 /var/log/app

echo "complete"
yum install -y amazon-cloudwatch-agent
mkdir -p /opt/aws/amazon-cloudwatch-agent/bin

echo "complete"
cat <<EOL > /opt/aws/amazon-cloudwatch-agent/bin/config.json
{
    "logs": {
        "logs_collected": {
            "files": {
                "collect_list": [
                    {
                        "file_path": "${var.log_group_path}",
                        "log_group_name": "${var.log_group_name}",
                        "log_stream_name": "api_{instance_id}",
                        "timestamp_format": "%Y-%m-%d %H:%M:%S"
                    }
                ]
            }
        }
    }
}
EOL

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config \
    -m ec2 \
    -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json \
    -s

sudo systemctl enable amazon-cloudwatch-agent
sudo systemctl start amazon-cloudwatch-agent
sudo systemctl restart amazon-cloudwatch-agent

echo "$(date '+%Y-%m-%d %H:%M:%S') Test log message" | sudo tee -a /var/log/app/app.log

nohup python3 app.py &
EOF
)

  metadata_options {
    http_tokens = "optional"
    http_put_response_hop_limit = 2
    http_endpoint = "enabled"
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups = [aws_security_group.web_api_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.prefix}-web-api-asg"
    }
  }
}