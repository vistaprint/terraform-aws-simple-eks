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
    condition      = length(setsubtract(var.cluster_log_types, ["api", "audit", "authenticator", "controllerManager", "scheduler"])) == 0
    error_message  = "Control plane logs can only be a list containing any of api, audit, authenticator, controllerManager or scheduler."
  }
}
