##########################################################
///ALBの定義
##########################################################
resource "aws_lb" "aws-tf-alb" {
  name               = "aws-tf-alb"
  internal           = false             #falseを指定するとインターネット向け,trueを指定すると内部向け
  load_balancer_type = "application"

  security_groups    = [
    aws_security_group.aws-tf-alb-security-group.id
  ]

  subnets            = [
      aws_subnet.aws-tf-public-subnet-1a.id,
      aws_subnet.aws-tf-public-subnet-1c.id,
  ]
}

##########################################################
///ALBに付与するセキュリティグループの定義
##########################################################
resource "aws_security_group" "aws-tf-alb-security-group" {
    name ="aws-tf-alb-security-group"
    vpc_id= aws_vpc.aws-tf-vpc.id
    ingress{
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
        cidr_blocks =["0.0.0.0/0"]
    }
   egress{
       from_port  = 0
       to_port    = 0
       protocol   = "-1"
       cidr_blocks=["0.0.0.0/0"]
   }
}
##########################################################
///ALBのリスナーの定義
##########################################################
resource "aws_lb_listener" "aws-tf-alb-listener" {
  load_balancer_arn = aws_lb.aws-tf-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws-tf-alb-target-group.arn
  }

}

///リスナールールの定義

resource "aws_lb_listener_rule" "aws-tf-alb-listener-rule" {
  listener_arn = aws_lb_listener.aws-tf-alb-listener.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws-tf-alb-target-group.arn
  }

  condition {
      path_pattern{
        values = ["/*"]
      }
  }
}

##########################################################
///ALBのターゲットグループの定義
##########################################################
resource "aws_lb_target_group" "aws-tf-alb-target-group" {
  name        = "aws-tf-alb-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.aws-tf-vpc.id

  health_check {
        path        = "/"
  }
}

///ターゲットグループをインスタンスに紐づける

resource "aws_lb_target_group_attachment" "aws-tf-alb-tg-attachment-web1" {
  target_group_arn = aws_lb_target_group.aws-tf-alb-target-group.arn
  target_id        = aws_instance.aws-tf-web-1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "aws-tf-alb-tg-attachment-web2" {
  target_group_arn = aws_lb_target_group.aws-tf-alb-target-group.arn
  target_id        = aws_instance.aws-tf-web-2.id
  port             = 80
}