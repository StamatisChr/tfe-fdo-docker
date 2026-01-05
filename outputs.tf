output "ubuntu_2404_ami_id" {
  value = data.aws_ami.ubuntu_2404.id
}

output "ubuntu_2404_ami_name" {
  value = data.aws_ami.ubuntu_2404.name
}

output "aws_region" {
  value = var.aws_region
}

output "tfe-docker-fqdn" {
  description = "tfe-fqdn"
  value       = "https://${var.tfe_dns_record}-${random_pet.hostname_suffix.id}.${var.hosted_zone_name}"

}

output "tfe-admin-console" {
  description = "tfe-admin-console-url"
  value       = "https://${var.tfe_dns_record}-${random_pet.hostname_suffix.id}.${var.hosted_zone_name}:${var.tfe_admin_https_port}"

}

output "start_aws_ssm_session" {
  value = "aws ssm start-session --target ${aws_instance.tfe_docker_instance.id} --region ${var.aws_region}"
}

output "stream_cloud_init_logs" {
  value = <<EOT
  aws ssm start-session \
  --target ${aws_instance.tfe_docker_instance.id} \
  --region ${var.aws_region} \
  --document-name AWS-StartInteractiveCommand \
  --parameters '{"command":["sudo tail -f /var/log/cloud-init-output.log"]}'
  EOT
}
