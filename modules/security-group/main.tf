resource "aws_security_group" "web_sg" {
  name        = "tf-deploy-sg-${var.environment}"
  description = "Security group for ${var.environment} web servers"
  vpc_id      = var.vpc_id

  # HTTPS access
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "tf-deploy-sg-${var.environment}"
    Environment = var.environment
  }
}