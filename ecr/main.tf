# ECR module for managing container repositories

resource "aws_ecr_repository" "ecr" {
  name = var.name
  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
    encryption_type = "AES256"
  }
  tags = { Name = var.name }
}
