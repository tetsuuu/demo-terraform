data "template_file" "userdata-bastion" {
  template = file("${path.module}/userdata-template/bastion.tpl")

  vars = {
    INSTANCE_NAME = "${var.service_name}-${var.short_env}-bastion"
  }
}

data "aws_ami" "recent_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-????.??.?.????????-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.recent_amazon_linux.image_id
  ebs_optimized               = false
  instance_type               = var.instance_type
  monitoring                  = false
  key_name                    = var.common_key
  subnet_id                   = element(var.public_subs, 0)
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  source_dest_check           = true
  iam_instance_profile        = "${var.service_name}-${var.short_env}-bastion"

  user_data = data.template_file.userdata-bastion.rendered

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = false
  }

  tags = {
    Name         = "${var.service_name}-${var.short_env}-bastion"
    Envvironment = var.environment
    Service      = var.service_name
  }

  volume_tags = {
    Name         = "${var.service_name}-${var.short_env}-bastion"
    Envvironment = var.environment
    Service      = var.service_name
  }

  lifecycle {
    ignore_changes = [
      "user_data",
      "instance_type",
      "key_name",
      "subnet_id",
      "vpc_security_group_ids",
    ]
  }
}

resource "aws_security_group" "bastion" {
  name        = "${var.service_name}-${var.short_env}-bastion"
  description = "Bastion operation Security Group"
  vpc_id      = var.service_vpc

  tags = {
    Name         = "${var.service_name}-${var.short_env}-bastion"
    Envvironment = var.environment
    Service      = var.service_name
  }
}

resource "aws_security_group_rule" "default_egress" {
  description       = "Allow egress to all"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "bastion_rule_tcp22" {
  description       = "SSH from maintenance vpc"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.developers_site
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "bastion_rule_tcp3306" {
  description              = "MySQL from maintenance vpc"
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = var.db_sg
  security_group_id        = aws_security_group.bastion.id
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${var.service_name}-${var.short_env}-bastion"
  role = "${var.service_name}-${var.short_env}-bastion"
}

resource "aws_iam_role" "bastion" {
  name               = "${var.service_name}-${var.short_env}-bastion"
  assume_role_policy = file("${path.module}/../../policy/iam_assumerole.json")
}
