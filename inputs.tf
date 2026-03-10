variable "bucket_name" {
  description = "The name of the S3 bucket to create for storing the Terraform state"
  type        = string
  default     = null
}

variable "use_dynamodb" {
  description = "Whether to create a DynamoDB table for storing the Terraform state lock. If false, S3 object locking will be used."
  type        = bool
  default     = false
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table to create for storing the Terraform state lock. If omitted, will autogenerate a name based on the AWS account ID."
  type        = string
  default     = null
}

variable "statefile_key" {
  description = "Sets the path and name of the key where the statefile will be stored in the bucket"
  type        = string
  default     = "terraform-state/main.tfstate"
}
