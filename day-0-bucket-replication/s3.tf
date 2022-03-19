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

resource "aws_s3_bucket_acl" "app-artifact-east-2" {
  bucket = aws_s3_bucket.app-artifact-east-2.id
  acl    = "private"

  provider = aws.east-2
}

resource "aws_s3_bucket_replication_configuration" "app-artifact-east-2" {
  bucket = aws_s3_bucket.app-artifact-east-2.id

  role = aws_iam_role.replication.arn

  rule {
    id     = "replication-to-${aws_s3_bucket.app-artifact-west-2.bucket}"
    status = "Enabled"

    source_selection_criteria {
      sse_kms_encrypted_objects {
        status = "Enabled"
      }
    }

    destination {
      bucket  = aws_s3_bucket.app-artifact-west-2.arn
      account = local.account_id
      encryption_configuration {
        replica_kms_key_id = aws_kms_key.bucket-encryption-west-2.arn
      }

      access_control_translation {
        owner = "Destination"
      }
    }
  }


  depends_on = [
    aws_s3_bucket_versioning.app-artifact-east-2
  ]

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

resource "aws_s3_bucket_replication_configuration" "app-artifact-west-2" {
  bucket = aws_s3_bucket.app-artifact-west-2.id

  role = aws_iam_role.replication.arn

  rule {
    id     = "replication-to-${aws_s3_bucket.app-artifact-east-2.bucket}"
    status = "Enabled"

    source_selection_criteria {
      sse_kms_encrypted_objects {
        status = "Enabled"
      }
    }

    destination {
      bucket  = aws_s3_bucket.app-artifact-east-2.arn
      account = local.account_id
      encryption_configuration {
        replica_kms_key_id = aws_kms_key.bucket-encryption-east-2.arn
      }

      access_control_translation {
        owner = "Destination"
      }
    }
  }


  depends_on = [
    aws_s3_bucket_versioning.app-artifact-west-2
  ]

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
