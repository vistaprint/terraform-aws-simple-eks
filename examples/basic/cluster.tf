module "cluster" {
  source  = "./../.."

  cluster_name      = "simple-eks-integration-test"
  cluster_version   = "1.21"
  vpc_name          = var.vpc_name
  cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  region  = var.aws_region
  profile = var.aws_profile
}

module "on_demand_node_group" {
  source = "vistaprint/simple-eks-node-group/aws"

  cluster_name       = "simple-eks-integration-test"
  node_group_name    = "on-demand"
  node_group_version = "1.21"

  instance_types = ["t3a.small"]

  scaling_config = {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  worker_role_arn = module.cluster.worker_role_arn
  subnet_ids      = module.cluster.private_subnet_ids

  use_calico_cni = false

  region  = var.aws_region
  profile = var.aws_profile

  depends_on = [module.cluster]
}
