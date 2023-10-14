provider "aws" {
    region = "eu-west-3"
}

variable "environment" {
  description = "deployment environment"
  default     = "development"
  type        = string
}

variable "avail_zone" {
  description = "availability zone"
  default     = "eu-west-3a"
}

variable "cidr_blocks" {
    description = "cidr blocks ans name tags for vpc and subnets"
    type = list(object({
        cidr_block = string
        name = string
    }))
  
}
variable "subnet_cidr_block" {
  description = "subnet cidr block"
  default = "10.0.10.0/24"
}
resource "aws_vpc" "development-vpc" {
    cidr_block = var.cidr_blocks[0].cidr_block
    tags={
        Name : var.cidr_blocks[0].name
    }
} 
resource "aws_subnet" "dev-subnet-1" {
    vpc_id = aws_vpc.development-vpc.id
    cidr_block = var.cidr_blocks[1].cidr_block
    availability_zone = var.avail_zone
    tags={
        Name : var.cidr_blocks[1].name
    }
}

data "aws_vpc" "existing_vpc" {
     default = true
}

resource "aws_subnet" "development-subnet-2" {
  vpc_id = data.aws_vpc.existing_vpc.id
  cidr_block = "172.31.48.0/20"
  availability_zone = "eu-west-3a"
  tags={
        Name : "subnet-2-defualt"
    }
}

output "dev-vpc-id" {
    value = aws_vpc.development-vpc.id
}
output "dev-subnet-id" {
    value = aws_subnet.dev-subnet-1.id
}