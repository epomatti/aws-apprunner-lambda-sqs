resource "aws_ecr_repository" "default" {
  name                 = var.workload
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}
