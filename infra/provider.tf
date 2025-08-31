provider "aws" {
  region = var.aws_region

  ignore_tags {
    # Ignores dynamic tags added by the Patch Policy
    key_prefixes = [
      "QSConfig"
    ]
  }
}
