module "vpc" {
  source = "./vpc"
  prefix = var.prefix
  region = var.region
}

/*
module "s3" {
  source = "./s3"
  prefix = var.prefix
  bucket_custom_prefix = var.bucket_custom_prefix

  depends_on = [ module.vpc ]
}


module "ec2" {
  source = "./bastion"
  prefix = var.prefix
  public_subnets = module.vpc.public_subnets
  aws_ami = data.aws_ami.al2023_ami_amd.id
  vpc_id = module.vpc.vpc_id
  file_bucket_name = module.s3.file_bucket_name
  be_repo_name = module.codecommit.be_repo_name
  region = var.region
  account_id = data.aws_caller_identity.current.account_id
  ecr_backend_name = module.ecr.ecr_backend_name
  task_definition_name = var.task_definition_name
  container_name = var.container_name
  container_port = var.container_port
  fe_repo_name = module.codecommit.fe_repo_name
  private_subnets = module.vpc.private_subnets
  default_branch = var.default_branch
  ecs_task_execution_role_name = var.ecs_task_execution_role_name
  service_sg_id = module.vpc.service_sg_id

  depends_on = [ module.ecr ]
}

module "alb" {
  source = "./alb"
  prefix = var.prefix
  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  alb_sg_id = module.vpc.alb_sg_id
}*/
