# EC2(web2)作成
resource "aws_instance" "aws-tf-web-2" {
  ami                     = "ami-0992fc94ca0f1415a"
  instance_type           = "t2.micro"
  associate_public_ip_address = "true"
  ebs_block_device {
    device_name    = "/dev/xvda"
    volume_type = "gp2"
    volume_size = 30
  }

  disable_api_termination = false
  key_name = aws_key_pair.auth.key_name
  vpc_security_group_ids  = [aws_security_group.aws-tf-public-security-group.id]
  subnet_id               = aws_subnet.aws-tf-public-subnet-1c.id
  user_data          = "${file("./userdata/cloud-init.tpl")}"
  tags = {
    Name = "aws-tf-web-2"
  }
}

#キーペア
resource "aws_key_pair" "auth" {
    key_name = "terraform-aws"
    public_key = file("~/.ssh/terraform-aws.pub")
}
