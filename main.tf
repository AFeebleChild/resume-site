provider "aws" {
  region  = "us-west-2"
  profile = "personal"
}

terraform {
  backend "s3" {
    bucket  = "afeeblechild-state"
    key     = "resume-site"
    region  = "us-west-2"
    profile = "personal"
  }
  required_version = ">= 1.3.3"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "resume.feeblelabs.com"
  acl    = "public-read"
  policy = file("bucket-policy.json")

  website {
    index_document = "index.html"

    routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
  }
}

resource "aws_s3_bucket_object" "resume" {
  bucket = aws_s3_bucket.bucket.bucket
  key = "index.html"
  source = "index.html"

  content_type = "text/html"
  etag = filemd5("index.html")
}

resource "aws_s3_bucket_object" "styles" {
  bucket = aws_s3_bucket.bucket.bucket
  key = "styles.css"
  source = "styles.css"

  content_type = "text/css"
  etag = filemd5("styles.css")
}
