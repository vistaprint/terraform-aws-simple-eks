terraform {
  required_version = ">= 1"
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
