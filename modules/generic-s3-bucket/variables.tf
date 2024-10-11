variable "generic-s3-bucket-name" {
  type = string
  description = "Name of the generic S3 bucket"
}

variable "block_public_policy" {
  type = map
  description = "Block public policy"
  default = {
    "BlockPublicAcls" = false
    "BlockPublicPolicy" = false
    "IgnorePublicAcls" = false
    "RestrictPublicBuckets" = false
  }
}

variable "aws_s3_bucket_versioning" {
  type = string
  description = "AWS S3 bucket versioning"
  default = "Disabled"
}