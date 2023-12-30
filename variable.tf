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
  default = "2"
}
variable "preferred_number_of_private_subnets" {
  default = "4"

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

variable "ami" {
  type    = string
  default = "ami-0b0af3577fe5e3532"

}


variable "keypair" {
  
  type = string

}

variable "account_no" {
  type        = number
  description = "the account number"
}

variable "master-username" {
  type        = string
  description = "RDS admin username"
}

variable "master-password" {
  type        = string
  description = "RDS master password"
}


