resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.role.arn

  vpc_config {
    subnet_ids = data.aws_subnet_ids.private.ids
  }

  version = var.cluster_version

  enabled_cluster_log_types = [
    "api",
    # "audit",  # generates quite a bit of data
    "authenticator"
  ]

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

resource "null_resource" "remove_aws_vpc_cni" {
  count = var.use_calico_cni ? 1 : 0

  triggers = {
    always_run = uuid()
  }

  provisioner "local-exec" {
    command = <<-EOT
      curl https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/release-1.7/config/v1.7/aws-k8s-cni.yaml |
        kubectl --context='${aws_eks_cluster.cluster.arn}' delete -f - || true
    EOT

    interpreter = ["bash", "-c"]
  }

  depends_on = [
    null_resource.check_aws_credentials_are_available,
    null_resource.update_kubeconfig_with_cluster_info
  ]
}

# Install Calico CNI provider
# (see https://docs.projectcalico.org/getting-started/kubernetes/managed-public-cloud/eks)

resource "null_resource" "install_calico_cni" {
  count = var.use_calico_cni ? 1 : 0

  triggers = {
    always_run = uuid()
  }

  provisioner "local-exec" {
    command = <<-EOT
      kubectl --context='${aws_eks_cluster.cluster.arn}' \
        apply -f https://docs.projectcalico.org/archive/v3.17/manifests/calico-vxlan.yaml
    EOT

    interpreter = ["bash", "-c"]
  }

  depends_on = [
    null_resource.remove_aws_vpc_cni,
    null_resource.check_aws_credentials_are_available,
    null_resource.update_kubeconfig_with_cluster_info
  ]
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = local.node_group_name
  node_role_arn   = aws_iam_role.worker_role.arn
  subnet_ids      = data.aws_subnet_ids.private.ids

  scaling_config {
    desired_size = var.scaling_config.desired_size
    max_size     = var.scaling_config.max_size
    min_size     = var.scaling_config.min_size
  }

  instance_types = var.use_calico_cni ? null : [var.instance_type]
  version        = var.use_calico_cni ? null : var.node_group_version

  dynamic "launch_template" {
    for_each = var.use_calico_cni ? [1] : []
    content {
      id      = aws_launch_template.worker_nodes[0].id
      version = aws_launch_template.worker_nodes[0].latest_version
    }
  }

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    null_resource.tag_subnets,
    null_resource.remove_aws_vpc_cni,
    null_resource.install_calico_cni
  ]

  lifecycle {
    ignore_changes = [
      # Ingores changes to scaling_config.desired_size.
      #
      # If cluster autoscaler changes the number of nodes, terraform will try
      # to adjust that number when updating the resource. This is something
      # most likely undesirable.
      #
      # Ideally we could do this only if var.enable_cluster_autoscaler is set
      # to true, but there is not really an easy way to do so.
      scaling_config[0].desired_size
    ]
  }
}
