output "worker_role_arn" {
  value = aws_iam_role.worker_role.arn
}

output "private_subnet_ids" {
  value = data.aws_subnet_ids.private.ids
}

output "oidc_identity_provider_issuer" {
  value = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}
