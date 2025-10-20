terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  bucket_name         = var.bucket_name != null ? var.bucket_name : "terraform-state-${data.aws_caller_identity.current.account_id}"
  dynamodb_table_name = var.dynamodb_table_name != null ? var.dynamodb_table_name : "terraform-state-${data.aws_caller_identity.current.account_id}"
  use_s3_locking      = var.dynamodb_table_name == null
}

resource "aws_s3_bucket" "state" {
  bucket = local.bucket_name
}

resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "state" {
  count = var.use_dynamodb ? 1 : 0

  name         = local.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

output "region" {
  description = "AWS region where state resources were created"
  value       = data.aws_region.current.region
}

output "account_id" {
  description = "AWS account ID where state resources were created"
  value       = data.aws_caller_identity.current.account_id
}

output "bucket" {
  description = "The name of the S3 bucket created for storing the Terraform state"
  value       = aws_s3_bucket.state.id
}

output "dynamodb_table" {
  description = "The name of the DynamoDB table created for storing the Terraform state lock, or null if not created"
  value       = var.use_dynamodb ? aws_dynamodb_table.state[0].name : null
}

output "terraform_backend_config" {
  description = "A terraform backend configuration template"
  value = templatefile("${path.module}/templates/backend.tftpl", {
    account_id     = data.aws_caller_identity.current.account_id
    use_s3_locking = local.use_s3_locking
    bucket         = aws_s3_bucket.state.id
    region         = data.aws_region.current.region
    dynamodb_table = local.dynamodb_table_name
  })
}
