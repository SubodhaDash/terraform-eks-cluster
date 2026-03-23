provider "aws" {
  region = "ap-south-2"
}

resource "aws_s3_bucket" "example" {
  bucket = "subodha-demo-terraform-eks-state-bucket"

  lifecycle {
    prevent_destroy = false
  }

}

resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.example.id

  versioning_configuration {
    status = "Enabled"
  }

}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name         = "terraform-eks-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}