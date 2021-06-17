locals {
  log_group_name = var.log_group_name == "" ? var.cluster_name : var.log_group_name
}