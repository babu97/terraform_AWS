output "dynamo_db_name" {
  
  value = aws_dynamodb_table.terraform_locks.name

}