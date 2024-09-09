module "ecs" {
  source = "./modules/ecs/"

  prefix                = var.prefix
  region                = var.region
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnets
  alb_target_group_arn  = aws_alb_target_group.this.arn
  alb_security_group_id = aws_security_group.alb.id
  db_address            = aws_db_instance.database.address
  db_name               = var.db_name
  db_username           = var.db_username
  db_secret_arn         = data.aws_secretsmanager_secret.db.arn
  db_secret_key_id      = data.aws_secretsmanager_secret.db.kms_key_id
}