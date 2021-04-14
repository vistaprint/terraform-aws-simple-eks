module "cluster" {
  source  = "./../.."

  cluster_name       = "simple-eks-integration-test"
  cluster_version    = "1.18"
  vpc_name           = var.vpc_name

  region  = var.aws_region
  profile = var.aws_profile
}
