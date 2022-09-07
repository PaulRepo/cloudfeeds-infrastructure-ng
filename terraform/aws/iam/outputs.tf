output "cloudfeeds_eks_cluster_role" {
  description = "Cluster Role"
  value       = aws_iam_role.cloudfeeds_eks_cluster_role.arn
}

output "cloudfeeds_eks_node_role" {
  description = "Cluster Node Role"
  value       = aws_iam_role.cloudfeeds_eks_node_role.arn
}

output "cloudfeeds_lambdafunc_role" {
  description = "Lambda Function Role"
  value       = aws_iam_role.iam_for_lambda.arn
}