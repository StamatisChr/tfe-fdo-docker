# Get the latest Ubuntu 24.04 ami for the region 
data "aws_ami" "hc-base-ubuntu-2404" {
  for_each = toset(["amd64", "arm64"])
  filter {
    name   = "name"
    values = [format("hc-base-ubuntu-2404-%s-*", each.value)]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
  most_recent = true
  owners      = ["888995627335"]
}

data "aws_vpc" "my-default" {}

data "aws_route53_zone" "my_aws_dns_zone" {
  name = var.hosted_zone_name
}

data "aws_iam_policy" "SecurityComputeAccess" {
  name = "SecurityComputeAccess"
}

