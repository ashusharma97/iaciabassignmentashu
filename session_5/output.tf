output "vpc_id" {
  description = "The VPC Id"
  value       = module.vpc.vpc_id
}

output "website_url" {
  description = "The website URL."
  value       = format("http://%s/users", aws_alb.this.dns_name)
}

output "ecr_url" {
  description = "The Elastic Container Registry (ECR) URL."
  value       = module.ecs.ecr_url
}
