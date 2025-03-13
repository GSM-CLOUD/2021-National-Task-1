module "vpc" {
  source = "./vpc"
  prefix = var.prefix
  region = var.region
}

module "s3" {
  source = "./s3"
  bucket_frontend_name = var.bucket_frontend_name
  bucket_backend_name = var.bucket_backend_name

  depends_on = [ module.vpc ]
}

module "cloudwatch" {
  source = "./cloudwatch"
  prefix = var.prefix

  depends_on = [ module.s3 ]
}

module "ec2" {
  source = "./bastion"
  prefix = var.prefix
  public_subnets = module.vpc.public_subnets
  aws_ami = data.aws_ami.al2023_ami_amd.id
  vpc_id = module.vpc.vpc_id

  depends_on = [ module.s3 ]
}

module "alb" {
  source = "./alb"
  prefix = var.prefix
  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  
  depends_on = [ module.ec2 ]
}

module "launch_template" {
  source = "./launchtemplate"
  prefix = var.prefix
  aws_ami = data.aws_ami.al2023_ami_amd.id
  key_name = module.ec2.key_name
  vpc_id = module.vpc.vpc_id
  alb_sg_id = module.alb.alb_sg_id
  bucket_backend_name = module.s3.bucket_backend_name
  log_group_name = var.log_group_name
  log_group_path = var.log_group_path

  depends_on = [ module.ec2 ]
}

module "asg" {
  source = "./autoscalinggroup"
  prefix = var.prefix
  launch_template_id = module.launch_template.launch_template_id
  private_subnets = module.vpc.private_subnets
  target_group_arn = module.alb.target_group_arn

  depends_on = [ module.launch_template ]
}

module "cloudfront" {
  source = "./cloudfront"
  prefix = var.prefix
  s3_bucket_dns_name = module.s3.bucket_dns_name
  s3_bucket_name = module.s3.bucket_frontend_name
  alb_dns_name = module.alb.alb_dns_name

  depends_on = [ module.asg ]
}

module "dashboard" {
  source = "./dashboard"
  alb_arn = module.alb.alb_arn

  depends_on = [ module.cloudfront ]
}