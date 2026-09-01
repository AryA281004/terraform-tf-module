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