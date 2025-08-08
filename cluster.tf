resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.cluster.arn

  bootstrap_self_managed_addons = false

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  compute_config {
    enabled = true
    # The general-purpose node pool is not created by default, as AWS will
    # create a node pool that can only use amd64 instances. This is not the
    # case with the system node pool, which can use both amd64 and arm64.
    # If this ever changes, we can enable the general-purpose node pool too.
    # node_pools    = ["general-purpose", "system"]
    node_pools    = ["system"]
    node_role_arn = aws_iam_role.node.arn
  }

  kubernetes_network_config {
    elastic_load_balancing {
      enabled = true
    }
  }

  storage_config {
    block_storage {
      enabled = true
    }
  }

  zonal_shift_config {
    enabled = true
  }

  vpc_config {
    subnet_ids = data.aws_subnets.private.ids
  }

  enabled_cluster_log_types = var.enabled_cluster_log_types

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSComputePolicy,
    aws_iam_role_policy_attachment.AmazonEKSBlockStoragePolicy,
    aws_iam_role_policy_attachment.AmazonEKSLoadBalancingPolicy,
    aws_iam_role_policy_attachment.AmazonEKSNetworkingPolicy,
  ]
}

resource "aws_cloudwatch_log_group" "control_plane_logs" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 30

  tags = var.tags
}
