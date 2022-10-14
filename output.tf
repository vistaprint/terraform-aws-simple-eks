output "cluster_name" {
  value = aws_eks_cluster.cluster.name
}

output "worker_role_arn" {
  value = aws_iam_role.worker_role.arn
}

output "private_subnet_ids" {
  value = data.aws_subnets.private.ids
}

output "oidc_identity_provider_issuer" {
  value = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}
