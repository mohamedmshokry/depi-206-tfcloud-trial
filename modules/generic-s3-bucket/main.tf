resource "aws_s3_bucket" "s3-bucket" {
  bucket = var.generic-s3-bucket-name
}

resource "aws_s3_bucket_public_access_block" "generic-s3-bucket-public-access" {
  bucket = aws_s3_bucket.s3-bucket.id

  block_public_acls       = var.block_public_policy["BlockPublicAcls"]
  block_public_policy     = var.block_public_policy["BlockPublicPolicy"]
  ignore_public_acls      = var.block_public_policy["IgnorePublicAcls"]
  restrict_public_buckets = var.block_public_policy["RestrictPublicBuckets"]
}

resource "aws_s3_bucket_versioning" "generic-s3-bucket-versioning" {
  bucket = aws_s3_bucket.s3-bucket.id
  versioning_configuration {
    status = var.aws_s3_bucket_versioning
  }
}