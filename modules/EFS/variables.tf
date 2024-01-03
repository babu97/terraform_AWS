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


variable "account_no" {
  type        = number
  description = "the account number"
}

variable "efs-subnet-2" {
  description = "Second subnet for the mount target"
}

variable "efs-subnet-1" {
  description = "First subnet for the mount target"
}

variable "efs-sg" {
  type        = list
  description = "security group for the file system"

} 