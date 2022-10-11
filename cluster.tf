resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.role.arn

  vpc_config {
    subnet_ids = data.aws_subnets.private.ids
  }

  version = var.cluster_version

  enabled_cluster_log_types = var.cluster_log_types

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
    aws_cloudwatch_log_group.control_plane_logs,
    null_resource.tag_subnets
  ]
}

resource "aws_cloudwatch_log_group" "control_plane_logs" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 30

  tags = var.tags
}
