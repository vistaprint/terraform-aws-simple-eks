# output "worker_role_arn" {
#   value = module.cluster.worker_role_arn
# }

# output "private_subnet_ids" {
#   value = module.cluster.private_subnet_ids
# }

output "oidc_identity_provider_issuer" {
  value = module.cluster.oidc_identity_provider_issuer
}
