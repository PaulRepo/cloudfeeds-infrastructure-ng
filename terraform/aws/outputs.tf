output "cf_bucket_arn" {
  description = "arn of the bucket."
  value       = module.s3_bucket.cloudfeeds_bucket_arn
}

output "cf_bucket_id" {
  description = "id of the bucket."
  value       = module.s3_bucket.cloudfeeds_bucket_id
}

output "cf_table_id" {
  description = "id of the dynamodb table"
  value       = module.dynamodb.cloudfeeds_table_id
}

output "cf_table_arn" {
  description = "arn of the dynamodb table"
  value       = module.dynamodb.cloudfeeds_table_arn
}

output "cf_bucket_all_tags" {
  value = module.s3_bucket.cloudfeeds_bucket_all_tags
}

output "cf_table_all_tags" {
  value = module.dynamodb.cloudfeeds_table_all_tags
}

output "cluster_id" {
  description = "EKS cluster ID."
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.eks.cluster_security_group_id
}

output "kubectl_config" {
  description = "kubectl config as generated by the module."
  value       = module.eks.kubeconfig
}

output "config_map_aws_auth" {
  description = "A kubernetes configuration to authenticate to this EKS cluster."
  value       = module.eks.config_map_aws_auth
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = local.cluster_name
}
