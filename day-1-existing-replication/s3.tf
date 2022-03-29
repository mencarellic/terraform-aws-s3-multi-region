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

resource "aws_s3_bucket_inventory" "app-artifact-east-2" {
  bucket = aws_s3_bucket.app-artifact-east-2.id
  name   = "EntireBucketDaily"

  included_object_versions = "Current"

  schedule {
    frequency = "Daily"
  }

  destination {
    bucket {
      format     = "CSV"
      bucket_arn = aws_s3_bucket.inventory.arn
    }
  }

  provider = aws.east-2
}

resource "aws_s3_object" "contents" {
  count = length(random_pet.contents)

  bucket  = aws_s3_bucket.app-artifact-east-2.bucket
  key     = "file-${count.index}"
  content = random_pet.contents[count.index].id

  provider = aws.east-2
}

resource "aws_s3_bucket" "inventory" {
  bucket = "mencarellic-s3-inventory"

  provider = aws.east-2
}


resource "aws_s3_bucket_policy" "inventory" {
  bucket = aws_s3_bucket.inventory.id
  policy = data.aws_iam_policy_document.inventory.json

  provider = aws.east-2
}

data "aws_iam_policy_document" "inventory" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      aws_s3_bucket.inventory.arn,
      "${aws_s3_bucket.inventory.arn}/*",
    ]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"

      values = [
        aws_s3_bucket.app-artifact-east-2.arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"

      values = [
        local.account_id
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control"
      ]
    }
  }
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
