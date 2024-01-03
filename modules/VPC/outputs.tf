
output "vpc_id" {
  value = aws_vpc.main.id
}
output "public_subnets-1" {
  value       = aws_subnet.public_subnet[0].id
  description = "The first public subnet in the subnets"
}

output "public_subnets-2" {
  value       = aws_subnet.public_subnet[1].id
  description = "The first public subnet"
}


output "private_subnets-1" {
  value       = aws_subnet.private_subnet[0].id
  description = "The first private subnet"
}

output "private_subnets-2" {
  value       = aws_subnet.private_subnet[1].id
  description = "The second private subnet"
}


output "private_subnets-3" {
  value       = aws_subnet.private_subnet[2].id
  description = "The third private subnet"
}


output "private_subnets-4" {
  value       = aws_subnet.private_subnet[3].id
  description = "The fourth private subnet"
}

output "instance_profile" {
  value = aws_iam_instance_profile.ip.id
}