data "aws_vpc" "eks_vpc" {
  tags = {
    Name = var.vpc_name
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.eks_vpc.id

  tags = {
    Type = "Public"
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.eks_vpc.id

  tags = {
    Type = "Private"
  }
}

# TODO: use aws_ec2_tag instead of kubectl

resource "null_resource" "tag_subnets" {
  triggers = {
    subnet_ids   = join(" ", setunion(data.aws_subnet_ids.public.ids, data.aws_subnet_ids.private.ids))
    cluster_name = var.cluster_name
    region       = var.region
    profile      = var.profile
  }

  provisioner "local-exec" {
    command = <<-EOT
      aws ec2 create-tags \
        --resource ${self.triggers.subnet_ids} \
        --tags "Key=kubernetes.io/cluster/${self.triggers.cluster_name},Value=shared" \
        --region=${self.triggers.region} \
        --profile ${self.triggers.profile}
    EOT

    interpreter = ["bash", "-c"]
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      aws ec2 delete-tags \
        --resource ${self.triggers.subnet_ids} \
        --tags "Key=kubernetes.io/cluster/${self.triggers.cluster_name},Value=shared" \
        --region=${self.triggers.region} \
        --profile ${self.triggers.profile}
    EOT

    interpreter = ["bash", "-c"]
  }

  depends_on = [null_resource.check_aws_credentials_are_available]
}
