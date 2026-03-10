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

variable "key_name" {
  description = "The name of the key where the statefile will be stored in the bucket. Appended to key_path."
  type        = string
  default     = "main.tfstate"
}

variable "key_path" {
  description = "Sets the path where the statefile will be stored in the bucket. The key_name will be appended to this path."
  type        = string
  default     = "terraform-state"
}
