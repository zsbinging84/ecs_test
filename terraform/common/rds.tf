# Security Group(Private)
resource "aws_security_group" "aws-tf-private-security-group" {
  description = "aws-tf-private-security-group"
  vpc_id      = aws_vpc.aws-tf-vpc.id
  tags = {
    Name = "aws-tf-private-security-group"
  }
}

# Mysqlアクセス許可のインバウンドルール
resource "aws_security_group_rule" "inbound_mysql" {
  type      = "ingress"
  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"
  cidr_blocks = [
    "0.0.0.0/0",
  ]
 
  # ここでweb_serverセキュリティグループに紐付け
  security_group_id = aws_security_group.aws-tf-private-security-group.id
}

# アウトバウンドルール(DB)
resource "aws_security_group_rule" "outbound_all-db" {
  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = -1
  cidr_blocks = [
    "0.0.0.0/0",
  ]
 
  # ここでweb_serverセキュリティグループに紐付け
  security_group_id = aws_security_group.aws-tf-private-security-group.id
}

# RDS用サブネットグループ(Private)
resource "aws_db_subnet_group" "aws-tf-private-subnet-group" {
    subnet_ids  = ["${aws_subnet.aws-tf-private-subnet-1a.id}", "${aws_subnet.aws-tf-private-subnet-1c.id}"]
    tags = {
        Name = "aws-tf-private-subnet-group"
    }
}

# RDSを作成
resource "aws_db_instance" "aws-tf-db" {
  identifier           = "aws-tf-db"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0.20"
  instance_class       = "db.t2.micro"
  name                 = "circlecitest"
  username             = "root"
  password             = "password"
  vpc_security_group_ids  = ["${aws_security_group.aws-tf-private-security-group.id}"]
  db_subnet_group_name = "${aws_db_subnet_group.aws-tf-private-subnet-group.name}"
  skip_final_snapshot = true
}