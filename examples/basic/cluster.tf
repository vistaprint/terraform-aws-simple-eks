module "cluster" {
  source = "./../.."

  cluster_name              = "simple-eks-integration-test"
  cluster_version           = "1.33"
  vpc_name                  = var.vpc_name
  enabled_cluster_log_types = ["api", "audit", "authenticator"]

  region  = var.aws_region
  profile = var.aws_profile
}
