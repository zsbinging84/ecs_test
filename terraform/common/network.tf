# VPC作成
resource "aws_vpc" "aws-tf-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "aws-tf-vpc"
  }
}

# EC2(web1)用サブネット作成(public)
resource "aws_subnet" "aws-tf-public-subnet-1a" {
  vpc_id            = aws_vpc.aws-tf-vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "aws-tf-public-subnet-1a"
  }
}

# EC2(web2)用サブネット作成(public)
resource "aws_subnet" "aws-tf-public-subnet-1c" {
  vpc_id            = aws_vpc.aws-tf-vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "aws-tf-public-subnet-1c"
  }
}
 
 # RDS用サブネット1作成(private)
resource "aws_subnet" "aws-tf-private-subnet-1a" {
  vpc_id            = aws_vpc.aws-tf-vpc.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "aws-tf-private-subnet-1a"
  }
}

# RDS用サブネット2作成(private)
resource "aws_subnet" "aws-tf-private-subnet-1c" {
  vpc_id            = aws_vpc.aws-tf-vpc.id
  cidr_block        = "10.0.21.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "aws-tf-private-subnet-1c"
  }
}

# インターネットゲートウェイの作成
resource "aws_internet_gateway" "aws-tf-igw" {
  vpc_id = aws_vpc.aws-tf-vpc.id
  tags = {
    Name = "aws-tf-igw"
  }
}
 
# ルートテーブルの作成
resource "aws_route_table" "aws-tf-public-route" {
  vpc_id = aws_vpc.aws-tf-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws-tf-igw.id
  }
  tags = {
    Name = "aws-tf-public-route"
  }
}
 
# サブネットの関連付けでルートテーブルをパブリックサブネット(web1)に紐付け
resource "aws_route_table_association" "aws-tf-public-subnet-association-1a" {
  subnet_id      = aws_subnet.aws-tf-public-subnet-1a.id
  route_table_id = aws_route_table.aws-tf-public-route.id
}

# サブネットの関連付けでルートテーブルをパブリックサブネット(web2)に紐付け
resource "aws_route_table_association" "aws-tf-public-subnet-association-1c" {
  subnet_id      = aws_subnet.aws-tf-public-subnet-1c.id
  route_table_id = aws_route_table.aws-tf-public-route.id
}

# Security Group(Public)
resource "aws_security_group" "aws-tf-public-security-group" {
  description = "aws-tf-public-security-group"
  vpc_id      = aws_vpc.aws-tf-vpc.id
  tags = {
    Name = "aws-tf-public-security-group"
  }
}

#アウトバウンドルール(WEB)
resource "aws_security_group_rule" "outbound_all-web" {
  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = -1
  cidr_blocks = [
    "0.0.0.0/0",
  ]
 
  # ここでweb_serverセキュリティグループに紐付け
  security_group_id = aws_security_group.aws-tf-public-security-group.id
}

# 80番ポート許可のインバウンドルール
resource "aws_security_group_rule" "inbound_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"
  cidr_blocks = [
    "0.0.0.0/0",
  ]
 
  # ここでweb_serverセキュリティグループに紐付け
  security_group_id = aws_security_group.aws-tf-public-security-group.id
}
 
# 22番ポート許可のインバウンドルール
resource "aws_security_group_rule" "inbound_ssh" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  cidr_blocks = [
    "0.0.0.0/0",
  ]
 
  # ここでweb_serverセキュリティグループに紐付け
  security_group_id = aws_security_group.aws-tf-public-security-group.id
}
