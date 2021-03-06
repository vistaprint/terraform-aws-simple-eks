terraform {
  required_version = ">= 0.12.26"
}

provider "aws" {}

variable "aws_profile" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "vpc_name" {
  type = string
}
