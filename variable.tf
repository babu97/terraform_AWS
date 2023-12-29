variable "region" {

  default = "eu-central-1"
}
variable "vpc_cidr" {
  default = "172.16.0.0/16"

}
variable "enable_dns_support" {
  default = "true"

}
variable "enable_dns_hostnames" {
  default = "true"

}

variable "preferred_number_of_public_subnets" {
  default = null
}
variable "preferred_number_of_private_subnets" {
  default = null

}

variable "tags" {
  description = "A mapping to assign to all resources"
  type        = map(string)
  default = {
    "name" = "value"
  }

}

variable "name" {
  type    = string
  default = "DEV"

}
