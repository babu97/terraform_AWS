region = "us-east-1"


vpc_cidr = "10.10.0.0/16"


enable_dns_support = "true"


enable_dns_hostnames = "true"


preferred_number_of_public_subnets  = 2
preferred_number_of_private_subnets = 4

tags = {
  Enviroment      = "Dev"
  Owner-Email     = "kelvinkiprop@gmail.com"
  Managed-By      = "kevin"
  Billing-Account = "254204724488"
}

account_no = 932861452532

master-username            = "admin"
master-password            = "Kipkulei123"
keypair                    = "kevin"
enable_deletion_protection = false

ami-nginx = "ami-0f678d6b7d76000ac"
ami-bastion = "ami-084e7ee4fab796cb5"
ami-web = "ami-021adf4372a674db1"
ami-sonar = "ami-07c3341c8109a24b3"

