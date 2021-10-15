resource "aws_security_group_rule" "eks_cluster_ingress_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"
  self      = true

  security_group_id = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
}

resource "aws_security_group_rule" "eks_cluster_ingress_custom" {
  type      = "ingress"
  from_port = 10250
  to_port   = 10250
  protocol  = "tcp"
  self      = true

  security_group_id = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
}

resource "aws_security_group_rule" "eks_cluster_egress_http_all" {
  type        = "egress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
}

resource "aws_security_group_rule" "eks_cluster_egress_https_all" {
  type        = "egress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
}

resource "aws_security_group_rule" "eks_cluster_egress_custom" {
  type      = "egress"
  from_port = 10250
  to_port   = 10250
  protocol  = "tcp"
  self      = true

  security_group_id = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
}
