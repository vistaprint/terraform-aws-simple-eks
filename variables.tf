variable "profile" {
  type = string
}

variable "region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "node_group_version" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "scaling_config" {
  type = object({
    desired_size = number,
    max_size     = number,
    min_size     = number
  })
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "use_calico_cni" {
  type    = bool
  default = false
}
