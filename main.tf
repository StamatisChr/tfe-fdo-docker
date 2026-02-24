
## random pet name to make the TFE fqdn change in every deployment 
resource "random_pet" "hostname_suffix" {
  length = 1
}


##### EC2 instance #####
# create ec2 instance
resource "aws_instance" "tfe_docker_instance" {
  ami             = data.aws_ami.hc-base-ubuntu-2404["amd64"].id
  instance_type   = var.tfe_instance_type
  security_groups = [aws_security_group.tfe_docker_sg.name]
  iam_instance_profile = aws_iam_instance_profile.ssm_role.name

  user_data = templatefile("./templates/user_data_cloud_init.tftpl", {
    tfe_host_path_to_certificates = var.tfe_host_path_to_certificates
    tfe_host_path_to_data         = var.tfe_host_path_to_data
    tfe_host_path_to_scripts      = var.tfe_host_path_to_scripts
    admin_username                = var.admin_username
    admin_email                   = var.admin_email
    admin_password                = var.admin_password
    tfe_license                   = var.tfe_license
    tfe_version_image             = var.tfe_version_image
    tfe_hostname                  = "${var.tfe_dns_record}-${random_pet.hostname_suffix.id}.${var.hosted_zone_name}"
    tfe_http_port                 = var.tfe_http_port
    tfe_https_port                = var.tfe_https_port
    tfe_admin_https_port          = var.tfe_admin_https_port
    tfe_encryption_password       = var.tfe_encryption_password
    cert                          = var.lets_encrypt_cert
    bundle                        = var.lets_encrypt_cert
    key                           = var.lets_encrypt_key
    oauth_token                   = var.oauth_token
  })

  ebs_optimized = true
  root_block_device {
    volume_size = 120
    volume_type = "gp3"
  }

  tags = {
    Name        = "stam-tfe-docker-instance"
    Environment = "stam-docker"
  }
}

resource "aws_eip" "tfe_eip" {
  instance = aws_instance.tfe_docker_instance.id
}
#### EC2 security group ######
# Security group for TFE docker. Ports needed: https://developer.hashicorp.com/terraform/enterprise/deploy/configuration/network
resource "aws_security_group" "tfe_docker_sg" {
  name        = "tfe_docker_sg"
  description = "Allow inbound traffic and outbound traffic for TFE"

  tags = {
    Name        = "tfe_docker_sg"
    Environment = "stam-docker"
  }
}

resource "aws_vpc_security_group_ingress_rule" "port_443_https" {
  security_group_id = aws_security_group.tfe_docker_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "port_80_http" {
  security_group_id = aws_security_group.tfe_docker_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "port_tfe_admin" {
  security_group_id = aws_security_group.tfe_docker_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.tfe_admin_https_port
  ip_protocol       = "tcp"
  to_port           = var.tfe_admin_https_port
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_traffic_ipv4" {
  security_group_id = aws_security_group.tfe_docker_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

####### DNS ########
#DNS record, points to the ec2 instance elastic ip. 
resource "aws_route53_record" "tfe-a-record" {
  zone_id = data.aws_route53_zone.my_aws_dns_zone.id
  name    = "${var.tfe_dns_record}-${random_pet.hostname_suffix.id}.${var.hosted_zone_name}"
  type    = "A"
  ttl     = 120
  records = [aws_eip.tfe_eip.public_ip]
}


# IAM Role for EC2 - SSM
resource "aws_iam_role" "ssm_role" {
  name = "ec2_ssm_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  tags = {
    Name = "stam-${random_pet.hostname_suffix.id}"
  }
}
# add the SecurityComputeAccess policy to IAM role connected to your EC2 instance
resource "aws_iam_role_policy_attachment" "SSM" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = data.aws_iam_policy.SecurityComputeAccess.arn
}

resource "aws_iam_instance_profile" "ssm_role" {
  name = "ec2_ssm_role_profile"
  role = aws_iam_role.ssm_role.name
}