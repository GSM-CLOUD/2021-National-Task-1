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


module "ec2" {
  source = "./bastion"
  prefix = var.prefix
  public_subnets = module.vpc.public_subnets
  aws_ami = data.aws_ami.al2023_ami_amd.id
  vpc_id = module.vpc.vpc_id
  bucket_backend_name = module.s3.bucket_backend_name

  depends_on = [ module.s3 ]
}

/*
module "alb" {
  source = "./alb"
  prefix = var.prefix
  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  alb_sg_id = module.vpc.alb_sg_id
}*/
