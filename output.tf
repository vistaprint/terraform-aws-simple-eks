output "cluster_name" {
  value = aws_eks_cluster.cluster.name
}

output "node_role_arn" {
  value = aws_iam_role.node.arn
}

output "private_subnet_ids" {
  value = data.aws_subnets.private.ids
}

output "oidc_identity_provider_issuer" {
  value = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}
