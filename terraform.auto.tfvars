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

ami-nginx = "ami-0b0af3577fe5e3532"
ami-bastion = "value"
ami-web = "value"
ami-sonar = "value"

