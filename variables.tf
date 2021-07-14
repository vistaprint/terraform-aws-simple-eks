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

variable "cluster_log_types" {
  type       = list(string)
  default    = ["api", "authenticator"]

  validation {
    condition      = length(setintersection(var.cluster_log_types, ["api", "audit", "authenticator", "controllerManager", "scheduler"])) > 0
    error_message  = "Control plane logs can only be a list containing any of api, audit, authenticator, controllerManager or scheduler."
  }
}
