resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "aws_ssm_parameter" "private" {
  name        = "/${var.environment}/ssh/aws/private"
  description = "Private key to login to the instances"
  type        = "SecureString"
  value       = tls_private_key.key.private_key_pem
  tags        = local.common_tags
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.environment}-main"
  public_key = tls_private_key.key.public_key_openssh
  tags       = local.common_tags
}
