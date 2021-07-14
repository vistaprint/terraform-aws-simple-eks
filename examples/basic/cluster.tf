module "cluster" {
  source  = "./../.."

  cluster_name      = "simple-eks-integration-test"
  cluster_version   = "1.20"
  vpc_name          = var.vpc_name
  log_group_name    = "a-test-log-group-name"
  cluster_log_types = ["api", "audit", "authenticator"]

  region  = var.aws_region
  profile = var.aws_profile
}
