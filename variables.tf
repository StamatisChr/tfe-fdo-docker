variable "aws_region" {
  description = "The AWS region in use to spawn the resources"
  type        = string
}

variable "tfe_instance_type" {
  description = "The ec2 instance type for TFE"
  type        = string
}

variable "hosted_zone_name" {
  description = "The zone ID of AWS hosted route53 zone"
  type        = string
}

variable "tfe_dns_record" {
  description = "The dns record of TFE instance"
  type        = string
}

variable "tfe_license" {
  description = "TFE license string"
  type        = string
}

variable "tfe_http_port" {
  description = "TFE container http port"
  type        = number
  default     = 8080
}

variable "tfe_https_port" {
  description = "TFE container https port"
  type        = number
  default     = 8443
}

variable "tfe_admin_https_port" {
  description = "TFE container admin port"
  type        = number
  default     = 8446
}

variable "tfe_encryption_password" {
  description = "TFE encryption password"
  type        = string
}

variable "tfe_version_image" {
  description = "The desired TFE version, example value: v202410-1"
  type        = string
}

variable "tfe_host_path_to_certificates" {
  description = "The path on the host machine to store the certificate files"
  type        = string
  default     = "/etc/terraform-enterprise/certs"
}

variable "tfe_host_path_to_data" {
  description = "The path on the host machine to store tfe data"
  type        = string
  default     = "/var/lib/terraform-enterprise/data"
}

variable "tfe_host_path_to_scripts" {
  description = "The path on the host machine to store tfe data"
  type        = string
  default     = "/var/lib/terraform-enterprise/scripts"
}

variable "lets_encrypt_cert" {
  description = "value"
  type        = string
  default     = "fullchain1.pem"

}

variable "lets_encrypt_key" {
  description = "value"
  type        = string
  default     = "privkey1.pem"
}

## Variables for TFE configuration: 
variable "admin_email" {
  type    = string
  default = "admin@example.com"
}

variable "admin_username" {
  type    = string
  default = "admin"

}
variable "admin_password" {
  type = string
}

variable "oauth_token" {
  description = "OAuth token for GitHub"
  type        = string
}