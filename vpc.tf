data "aws_vpc" "eks_vpc" {
  tags = {
    Name = var.vpc_name
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks_vpc.id]
  }

  tags = {
    Type = "Private"
  }
}
