output "aws_vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "aws_vpc_name" {
  description = "The name of the VPC"
  value       = aws_vpc.this.tags
}

output "aws_public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = [for subnet in aws_subnet.public : subnet.id]
}
output "aws_public_subnet_cidrs" {
  description = "The CIDR blocks of the public subnets"
  value       = [for subnet in aws_subnet.public : subnet.cidr_block]
}


output "aws_private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = [for subnet in aws_subnet.private : subnet.id]
}
output "aws_private_subnet_cidrs" {
  description = "The CIDR blocks of the private subnets"
  value       = [for subnet in aws_subnet.private : subnet.cidr_block]
}

output "aws_data_subnet_ids" {
  description = "The IDs of the data subnets"
  value       = [for subnet in aws_subnet.data : subnet.id]
}
output "aws_data_subnet_cidrs" {
  description = "The CIDR blocks of the data subnets"
  value       = [for subnet in aws_subnet.data : subnet.cidr_block]
}


output "aws_internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.this.id
}
output "aws_public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public_rt.id
}
output "aws_public_route_table_association_ids" {
  description = "The IDs of the public route table associations"
  value       = [for assoc in aws_route_table_association.public_rt_assoc : assoc.id]
}


output "aws_private_route_table_id" {
  description = "The ID of the private route table"
  value       = aws_route_table.private_rt.id
}
output "aws_eip"{
    description = "The Elastic IP address"
    value       = aws_eip.nat_eip.public_ip
}
output "aws_nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.nat_gw.id
}
output "aws_private_route_table_association_ids" {
  description = "The IDs of the private route table associations"
  value       = [for assoc in aws_route_table_association.private_rt_assoc : assoc.id]
}



