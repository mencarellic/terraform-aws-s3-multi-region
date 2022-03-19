resource "aws_s3_bucket" "app-artifact-east-2" {
  bucket = "mencarelli-${random_pet.s3-bucket.id}-east-2"

  provider = aws.east-2
}

resource "aws_s3_bucket_public_access_block" "app-artifact-east-2" {
  bucket                  = aws_s3_bucket.app-artifact-east-2.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  provider = aws.east-2
}

resource "aws_s3_bucket_versioning" "app-artifact-east-2" {
  bucket = aws_s3_bucket.app-artifact-east-2.id
  versioning_configuration {
    status = "Enabled"
  }

  provider = aws.east-2
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app-artifact-east-2" {
  bucket = aws_s3_bucket.app-artifact-east-2.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.bucket-encryption-east-2.arn
      sse_algorithm     = "aws:kms"
    }
  }

  provider = aws.east-2
}

resource "aws_s3_bucket" "app-artifact-west-2" {
  bucket = "mencarelli-${random_pet.s3-bucket.id}-west-2"

  provider = aws.west-2
}

resource "aws_s3_bucket_public_access_block" "app-artifact-west-2" {
  bucket                  = aws_s3_bucket.app-artifact-west-2.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  provider = aws.west-2
}

resource "aws_s3_bucket_versioning" "app-artifact-west-2" {
  bucket = aws_s3_bucket.app-artifact-west-2.id
  versioning_configuration {
    status = "Enabled"
  }

  provider = aws.west-2
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app-artifact-west-2" {
  bucket = aws_s3_bucket.app-artifact-west-2.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.bucket-encryption-west-2.arn
      sse_algorithm     = "aws:kms"
    }
  }

  provider = aws.west-2
}

resource "aws_s3_bucket_acl" "app-artifact-west-2" {
  bucket = aws_s3_bucket.app-artifact-west-2.id
  acl    = "private"

  provider = aws.west-2
}
