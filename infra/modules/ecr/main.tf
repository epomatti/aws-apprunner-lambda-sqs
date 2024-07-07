resource "aws_ecr_repository" "default" {
  name                 = "apprunner"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}
