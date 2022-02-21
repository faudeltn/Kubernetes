variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1" #eu-west-1
}

variable "aws_profile" {
  description = "The AWS profile to use."
  default     = "test"
}

variable "vpc_cidr_block" {
  type        = string
  default     = "10.1.0.0/16"
  description = "cidr block"
}

variable "prefix" {
  type        = string
  default     = "phoenix"
}

variable "environment" {
  type        = string
  default     = "prod"
}

variable "eks_cluster_name" {
    type        = string
    default     = "eks-demo"
}