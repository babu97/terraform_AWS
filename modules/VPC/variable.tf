
variable "region" {
  type    = string
  default = "us-west-2"  # Replace with your desired region
}

variable "vpc_cidr" {
  type    = string
}

variable "tags" {
  type        = map(string)
  description = "A mapping to assign to all resources"
  default     = {
    "name" = "value"
  }
}

variable "name" {
  type    = string
  default = "DEV"
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "preferred_number_of_public_subnets" {
  type    = number
  default = 2
}

variable "preferred_number_of_private_subnets" {
  type    = number
  default = 4
}