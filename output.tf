output "oidc_identity_provider_issuer" {
  value = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}
