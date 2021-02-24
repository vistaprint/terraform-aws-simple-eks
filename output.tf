output "worker_role_arn" {
  value = aws_iam_role.worker_role.arn
}

output "private_subnet_ids" {
  value = data.aws_subnet_ids.private.ids
}
