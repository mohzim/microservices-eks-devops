# Purpose: Define the variables that will be used in the terraform code
# The variables are defined in this file and used in the main terraform code

variable "kubernetes_version" {
  default     = 1.27
  description = "kubernetes version"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "default CIDR range of the VPC"
}
variable "aws_region" {
  default = "ap-south-1"
  description = "aws region"
}