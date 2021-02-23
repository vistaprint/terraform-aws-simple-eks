locals {
  x86_64_ami = "amazon-eks-node-${var.cluster_version}-v*"
  arm64_ami  = "amazon-eks-arm64-node-${var.cluster_version}-v*"
}

data "aws_ami" "ami" {
  most_recent = true
  name_regex  = var.architecture == "x86_64" ? local.x86_64_ami : local.arm64_ami
  owners      = ["amazon"]
}

resource "aws_launch_template" "worker_nodes" {
  count = var.use_calico_cni ? 1 : 0

  name = "${var.cluster_name}-eks-cluster-calico"

  image_id = data.aws_ami.ami.id

  instance_type = var.instance_type

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 20
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  network_interfaces {
    device_index    = 0
    security_groups = [aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id]
  }

  ebs_optimized = false

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 2
  }

  dynamic "tag_specifications" {
    for_each = length(var.tags) > 0 ? ["instance", "volume"] : []
    content {
      resource_type = tag_specifications.value
      tags          = var.tags
    }
  }

  user_data = base64encode(data.template_file.launch_template_userdata[0].rendered)
}

data "template_file" "launch_template_userdata" {
  count    = var.use_calico_cni ? 1 : 0
  template = file("${path.module}/data/userdata.tpl")

  vars = {
    cluster_name               = var.cluster_name
    cluster_endpoint           = aws_eks_cluster.cluster.endpoint
    certificate_authority_data = aws_eks_cluster.cluster.certificate_authority[0].data
    bootstrap_extra_args       = "--use-max-pods false"
    ami_id                     = data.aws_ami.ami.id
    node_group_name            = local.node_group_name
  }
}
