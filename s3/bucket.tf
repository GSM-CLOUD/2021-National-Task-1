resource "aws_s3_bucket" "s3_bucket_frontend" {
  bucket = var.bucket_frontend_name
  force_destroy = true

  website {
    index_document = "index.html"
  }
  
  tags = {
    "Name" = var.bucket_frontend_name
  }
}

resource "aws_s3_bucket_public_access_block" "s3_backend_bucket_public_access" {
  bucket                  = aws_s3_bucket.s3_bucket_frontend.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "s3_bucket_backend" {
  bucket = var.bucket_backend_name
  force_destroy = true

  tags = {
    "Name" = var.bucket_backend_name
  }
}

resource "aws_s3_bucket_public_access_block" "s3_frontend_bucket_public_access" {
  bucket                  = aws_s3_bucket.s3_bucket_backend.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "frontend_src" {
  bucket = aws_s3_bucket.s3_bucket_frontend.id
  key = "index.html"
  source = "${path.module}/app/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "backend_src" {
  bucket = aws_s3_bucket.s3_bucket_backend.id
  key = "app.py"
  source = "${path.module}/app/app.py"
  content_type = "application/python"
}