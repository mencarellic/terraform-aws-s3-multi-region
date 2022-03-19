resource "aws_s3_bucket_public_access_block" "app-artifact-east-2" {
  bucket                  = aws_s3_bucket.app-artifact-east-2.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  provider = aws.east-2
}

resource "aws_s3_bucket" "app-artifact-east-2" {
  bucket = "mencarelli-${random_pet.s3-bucket.id}-east-2"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket-encryption-east-2.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  replication_configuration {
    role = aws_iam_role.replication[0].arn

    rules {
      id       = "replication-to-${aws_s3_bucket.app-artifact-west-2.bucket}-west-2"
      priority = 0
      status   = "Enabled"

      source_selection_criteria {
        sse_kms_encrypted_objects {
          enabled = true
        }
      }

      destination {
        bucket             = aws_s3_bucket.app-artifact-west-2.arn
        account_id         = local.account_id
        replica_kms_key_id = aws_kms_key.bucket-encryption-west-2.arn

        access_control_translation {
          owner = "Destination"
        }
      }
    }
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
  bucket = "mencarelli-${random_pet.s3-bucket.id}-west-2"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket-encryption-west-2.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  replication_configuration {
    role = aws_iam_role.replication[0].arn

    rules {
      id       = "replication-to-${aws_s3_bucket.app-artifact-east-2.bucket}-east-2"
      priority = 0
      status   = "Enabled"

      source_selection_criteria {
        sse_kms_encrypted_objects {
          enabled = true
        }
      }

      destination {
        bucket             = aws_s3_bucket.app-artifact-east-2.arn
        account_id         = local.account_id
        replica_kms_key_id = aws_kms_key.bucket-encryption-east-2.arn

        access_control_translation {
          owner = "Destination"
        }
      }
    }
  }

  provider = aws.west-2
}

resource "aws_s3control_multi_region_access_point" "app-artifact" {
  details {
    name = "app-artifact"

    region {
      bucket = aws_s3_bucket.app-artifact-east-2.id
    }

    region {
      bucket = aws_s3_bucket.app-artifact-west-2.id
    }
  }
}