provider "aws" {
  region = var.region

}
#create vpc 
resource "aws_vpc" "main" {

  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(var.tags,
    {
      name = format("%s-VPC", var.name)
  })

}
#create public subnets1


resource "aws_subnet" "public_subnet" {
  count                   = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = merge(var.tags,
    {
      name = format("%s- publicSubnet -%s",var.name, count.index)
  })
}

#create public subnet2


resource "aws_subnet" "private_subnet" {
  count                   = var.preferred_number_of_private_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_private_subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 5, count.index+2)
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = merge(var.tags,
    {
      name = format("%s-privateSubnet-%s",var.name, count.index)
  })

}



#Get list of availability zones

data "aws_availability_zones" "available" {
  state = "available"

}

























