# ============================================================
# VPC
# ============================================================

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.environment}-${var.vpc_name}-vpc"
    Environment = var.environment
  }
}


# ============================================================
# PUBLIC / PRIVATE / DATA SUBNETS
# ============================================================

# ------------------------------------------------------------
# Public Subnets
# ------------------------------------------------------------

resource "aws_subnet" "public" {
  for_each = var.public_subnet_cidr

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-${var.vpc_name}-${each.key}-public-subnet"
    Environment = var.environment
    Type        = "public"
  }
}


# ------------------------------------------------------------
# Private Subnets
# ------------------------------------------------------------

resource "aws_subnet" "private" {
  for_each = var.private_subnet_cidr

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = {
    Name        = "${var.environment}-${var.vpc_name}-${each.key}-private-subnet"
    Environment = var.environment
    Type        = "private"
  }
}


# ------------------------------------------------------------
# Data Subnets
# ------------------------------------------------------------

resource "aws_subnet" "data" {
  for_each = var.data_subnet_cidr

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = {
    Name        = "${var.environment}-${var.vpc_name}-${each.key}-data-subnet"
    Environment = var.environment
    Type        = "data"
  }
}




# ============================================================
# PUBLIC ROUTE TABLE
# ============================================================

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.environment}-${var.vpc_name}-public-rt"
    Environment = var.environment
  }
}

# ------------------------------------------------------------
# Public Subnet → Public Route Table
# ------------------------------------------------------------

resource "aws_route_table_association" "public_rt_assoc" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

# ============================================================
# INTERNET GATEWAY
# ============================================================

resource "aws_internet_gateway" "public_igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.environment}-${var.vpc_name}-igw"
    Environment = var.environment
  }
}

# ------------------------------------------------------------
# Public Route → Internet Gateway
# ------------------------------------------------------------

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public_igw.id
}



# ============================================================
# PRIVATE ROUTE TABLE
# ============================================================

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.environment}-${var.vpc_name}-private-rt"
    Environment = var.environment
  }
}



# ------------------------------------------------------------
# Private Subnets → Private Route Table
# ------------------------------------------------------------

resource "aws_route_table_association" "private_rt_assoc" {
  for_each = merge(aws_subnet.private, aws_subnet.data)

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}



# ============================================================
# Elastic IP for NAT Gateway
# ============================================================

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name        = "${var.environment}-${var.vpc_name}-nat-eip"
    Environment = var.environment
  }
}



# ============================================================
# NAT GATEWAY
# ============================================================

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id

  subnet_id = aws_subnet.public[var.nat_gateway_subnet_key].id

  tags = {
    Name        = "${var.environment}-${var.vpc_name}-nat-gw"
    Environment = var.environment
  }

  depends_on = [
    aws_internet_gateway.public_igw
  ]
}



# ------------------------------------------------------------
# Private Route → NAT Gateway
# ------------------------------------------------------------

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}