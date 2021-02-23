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

variable "architecture" {
  type    = string
  default = "x86_64"

  validation {
    condition     = var.architecture == "x86_64" || var.architecture == "arm64"
    error_message = "Invalid value for architecture (must be x86_64 or arm64)."
  }
}

variable "use_calico_cni" {
  type    = bool
  default = false
}
