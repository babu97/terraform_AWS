# terraform {
#   backend "s3" {
#     bucket         = "dev-terraform-bucket-sai"
#     key            = "global/s3/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-locks"
#     encrypt        = true
#   }
# }
