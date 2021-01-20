output "name" {
  value = aws_eks_cluster.cluster.name
}

output "oidc_provider_arn" {  
  value = length(aws_iam_openid_connect_provider.provider) == 0 ? null : aws_iam_openid_connect_provider.provider.0.arn
}

output "oidc_provider_url" {
  value = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}
