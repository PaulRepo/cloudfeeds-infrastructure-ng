output "cloudfeeds_eks_cluster_role" {
  description = "Cluster Role"
  value       = aws_iam_role.cloudfeeds_eks_cluster_role.arn
}

output "cloudfeeds_eks_node_role" {
  description = "Cluster Node Role"
  value       = aws_iam_role.cloudfeeds_eks_node_role.arn
}
