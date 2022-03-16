resource "aws_s3_bucket_public_access_block" "app-artifact-east-2" {
  bucket                  = aws_s3_bucket.app-artifact-east-2.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  provider = aws.east-2
}

resource "aws_s3_bucket" "app-artifact-east-2" {
  bucket = "this-is-my-app-east-2"
  acl    = "private"

  versioning {
    enabled = true
  }

  provider = aws.east-2
}

resource "aws_s3_bucket_public_access_block" "app-artifact-west-2" {
  bucket                  = aws_s3_bucket.app-artifact-west-2.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  provider = aws.west-2
}

resource "aws_s3_bucket" "app-artifact-west-2" {
  bucket = "this-is-my-app-west-2"
  acl    = "private"

  versioning {
    enabled = true
  }

  provider = aws.west-2
}
