variable "profile" {
  type = string
}

variable "region" {
  type = string
}

variable "cluster_name" {
  type = string
}

# If this variable is an empty string, the
# log group name will be var.cluster_name
variable "log_group_name" {
  type    = string
  default = null
}

variable "cluster_version" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "use_calico_cni" {
  type    = bool
  default = false
}
