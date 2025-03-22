resource "aws_s3_bucket" "main" {
  bucket        = "bucket-${var.workload}-lambda-deploy-local"
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
