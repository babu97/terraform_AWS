variable "region" {

  default = "eu-central-1"
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





variable "enable_deletion_protection" {
  type        = bool
  description = "control when to delete LB"
}

variable "preferred_number_of_public_subnets" {
  type    = number
  default = 2
}

variable "preferred_number_of_private_subnets" {
  type    = number
  default = 4
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "vpc_cidr" {
  type = string
}


variable "master-username" {
  type        = string
  description = "RDS admin username"
}

variable "master-password" {
  type        = string
  description = "RDS master password"
}


variable "account_no" {
  type        = number
  description = "the account number"
}

variable "ami-web" {
  type        = string
  description = "Required AMI images"

}
variable "ami-nginx" {
  type        = string
  description = "Required AMI images"

}

variable "ami-bastion" {
  type        = string
  description = "Required AMI images"

}

variable "ami-sonar" {
  type        = string
  description = "Required AMI images"

}

variable "keypair" {

  type = string

}


