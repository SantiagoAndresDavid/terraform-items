//create s3 bucket resource
resource "aws_s3_bucket" "items-bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "items-01" {
  bucket = aws_s3_bucket.items-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

