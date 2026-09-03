variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "my-vpc"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "A map of public subnet CIDR blocks and their availability zones"
  type        = map(object({
    cidr_block = string
    az         = string
  }))
  default     = {
    public_subnet_1a = {
      cidr_block = "10.1.0.0/24"
      az         = "us-east-1a"
    }
    public_subnet_1b = {
      cidr_block = "10.2.0.0/24"
      az         = "us-east-1b"
    }
    public_subnet_1c = {
      cidr_block = "10.3.0.0/24"
      az         = "us-east-1c"
    }

    }
}

variable "private_subnet_cidr" {
  description = "A map of private subnet CIDR blocks and their availability zones"
  type        = map(object({
    cidr_block = string
    az         = string
  }))
  default     = {
    private_subnet_1a = {
      cidr_block = "10.4.0.0/24"
      az         = "us-east-1a"
    }
    private_subnet_1b = {
      cidr_block = "10.5.0.0/24"
      az         = "us-east-1b"
    }
    private_subnet_1c = {
      cidr_block = "10.6.0.0/24"
      az         = "us-east-1c"
    }

    }
}

variable "data_subnet_cidr" {
  description = "A map of data subnet CIDR blocks and their availability zones"
  type        = map(object({
    cidr_block = string
    az         = string
  }))
  default     = {
    data_subnet_1a = {
      cidr_block = "10.7.0.0/24"
      az         = "us-east-1a"
    }
    data_subnet_1b = {
      cidr_block = "10.8.0.0/24"
      az         = "us-east-1b"
    }
    data_subnet_1c = {
      cidr_block = "10.9.0.0/24"
      az         = "us-east-1c"
    }

    }
}

variable "environment" {
  description = "The environment for the VPC (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "nat_gateway_subnet_key" { 
    description = "Key of the public subnet where the NAT Gateway will be created" 
    type = string 
    validation { 
        condition = contains(keys(var.public_subnet_cidr), var.nat_gateway_subnet_key) 
        error_message = "nat_gateway_subnet_key must match a key in public_subnet_cidr." 
        } 
    }



    variable "security_all_group" {
        description = "A map of security group names and their descriptions"
        type        = map(string)
        default     = {
            alb-sg  = {
                description = "Security group for the Application Load Balancer"
                vpc_id      = aws_vpc.this.id

                ingress = [
                    {
                        from_port   = 80
                        to_port     = 80
                        protocol    = "tcp"
                        cidr_blocks = ["0.0.0/0"]
                    },
                    {
                        from_port   = 443
                        to_port     = 443
                        protocol    = "tcp"
                        cidr_blocks = ["0.0.0/0"]
                    }
                ]
                egress = [
                    {
                        from_port   = 0
                        to_port     = 0
                        protocol    = "-1"
                        cidr_blocks = ["0.0.0/0"]
                    }
                ]
            }
            container-sg  = {
                description = "Security group for the ECS container instances"
                vpc_id      = aws_vpc.this.id

                ingress = [
                    {
                        from_port   = 8000
                        to_port     = 8000
                        protocol    = "tcp"
                        cidr_blocks = ["0.0.0/0"]
                    }
                ]
                egress = [
                    {
                        from_port   = 0
                        to_port     = 0
                        protocol    = "-1"
                        cidr_blocks = ["0.0.0/0"]
                    }
                ]
            }
            rds-sg  = {
                description = "Security group for the RDS instances"
                vpc_id      = aws_vpc.this.id

                ingress = [
                    {
                        from_port   = 3306
                        to_port     = 3306
                        protocol    = "tcp"
                        cidr_blocks = ["0.0.0/0"]
                    }
                ]
                egress = [
                    {
                        from_port   = 0
                        to_port     = 0
                        protocol    = "-1"
                        cidr_blocks = ["0.0.0/0"]
                    }
                ]
            }
             
        }
    }