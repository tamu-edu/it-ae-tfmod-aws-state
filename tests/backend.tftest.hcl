run "setup_tests" {
    module {
        source = "./tests/setup"
    }
}

run "with_dynamodb" {
  command = apply

  variables {
    bucket_name         = "${run.setup_tests.bucket_prefix}-state-test"
    dynamodb_table_name = "my-terraform-lock-table"
    use_dynamodb        = true
  }

  # Check that the bucket name is correct
  assert {
    condition     = aws_s3_bucket.state.bucket == "${run.setup_tests.bucket_prefix}-state-test"
    error_message = "Invalid bucket name"
  }

  # Check that a DynamoDB table will be created
  assert {
    condition     = length(aws_dynamodb_table.state) == 1
    error_message = "DynamoDB table was not created"
  }
}

run "without_dynamodb" {
  command = apply

  variables {
    bucket_name         = "${run.setup_tests.bucket_prefix}-state-test"
  }

  # Check that the bucket name is correct
  assert {
    condition     = aws_s3_bucket.state.bucket == "${run.setup_tests.bucket_prefix}-state-test"
    error_message = "Invalid bucket name"
  }

  # Check that a DynamoDB table will not be created
  assert {
    condition     = length(aws_dynamodb_table.state) == 0
    error_message = "DynamoDB table was created when it should not have been"
  }
}