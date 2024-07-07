resource "aws_ecr_repository" "default" {
  name                 = "easybank"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}
