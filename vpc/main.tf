
############################################################
# VPC Module for ECS Fargate
############################################################


############################################################
# Data Source: Availability Zones
############################################################
data "aws_availability_zones" "available" {}


############################################################
# VPC Resource
############################################################
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name        = "${var.project}-vpc-${var.environment}"
    Environment = var.environment
    Project     = var.project
    ManagedBy = var.managed_by
  }
}


############################################################
# Public Subnets
############################################################
resource "aws_subnet" "public" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "${var.project}-public-subnet-${count.index}-${var.environment}"
    Environment = var.environment
    Project     = var.project
    ManagedBy = var.managed_by
  }
}


############################################################
# Private Subnets
############################################################
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnets[count.index]
  map_public_ip_on_launch = false
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "${var.project}-private-subnet-${count.index}-${var.environment}"
    Environment = var.environment
    Project     = var.project
    ManagedBy = var.managed_by
  }
}

############################################################
# Private Route Table (shared across all private subnets)
############################################################
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.project}-private-rt-${var.environment}"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = var.managed_by
  }
}

############################################################
# Associate all private subnets to the shared private route table
############################################################
resource "aws_route_table_association" "private_assoc" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

############################################################
# Internet Gateway (conditionally created)
############################################################
resource "aws_internet_gateway" "igw" {
  for_each = var.enable_public_route ? { "igw" = 1 } : {}

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.project}-igw-${var.environment}"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = var.managed_by
  }
}

############################################################
# Public Route Table (conditionally created)
############################################################
resource "aws_route_table" "public" {
  for_each = var.enable_public_route ? { "public" = 1 } : {}

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw["igw"].id
  }

  tags = {
    Name        = "${var.project}-public-rt-${var.environment}"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = var.managed_by
  }
}

############################################################
# Associate public subnets with public route table
############################################################
resource "aws_route_table_association" "public_assoc" {
  count          = var.enable_public_route ? length(var.public_subnets) : 0
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public["public"].id
}