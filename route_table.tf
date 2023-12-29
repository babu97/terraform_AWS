
#create private route table
resource "aws_route_table" "priavte-rtb" {
    vpc_id = aws_vpc.main.id
    tags = mergea(
        var.tags, 
        {
            Name = format("%s-Private-Route-Table", var.name)

        },

    )
}
#associateall the private subnets to the private route table
resource "aws_route_table_association" "private_subnets-assoc" {
    count = length(aws_subnet.private_subnet[*].id)
    subnet_id = element(aws_subnet.private_subnet[*], count.index)
    route_table_id = aws_route_table.priavte-rtb.id
  
}