resource "tls_private_key" "bastin-key" {
    algorithm = "RSA"
    rsa_bits = 2048

}

resource "aws_key_pair" "bastion-key-pair" {
  key_name = "${var.prefix}-key"
  public_key = tls_private_key.bastin-key.public_key_openssh
}

resource "local_file" "bastion_private_key" {
  content = tls_private_key.bastin-key.private_key_pem
  filename = "${path.module}/bastion_key.pem"
}

resource "aws_instance" "bastion" {
  ami = var.aws_ami
  instance_type = "t3a.small"

  subnet_id = var.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  key_name = aws_key_pair.bastion-key-pair.key_name
  iam_instance_profile = aws_iam_instance_profile.bastion_instance_profile.name

  user_data = <<-EOF
#!/bin/bash
sudo su
set -e
set -x

echo "complete"
yum install -y docker
systemctl enable docker
systemctl restart docker

echo "complete"
aws s3 cp s3://${var.bucket_backend_name}/app.py .

EOF



  tags = {
    "Name" = "${var.prefix}-bastion-ec2"
  }
}

resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion.id
  
  tags = {
    Name = "${var.prefix}-bastion-eip"
  }
}