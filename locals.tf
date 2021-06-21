locals {
  log_group_name = var.log_group_name == null ? var.cluster_name : var.log_group_name
}