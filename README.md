# it-ae-tfmod-aws-state
This is a terraform module for initializing a terraform state backend in AWS. It supports DynamoDB or S3 object locking for state locking and outputs a ready-to-use backend configuration to include in your main terraform code.

## Example usage

A common pattern for using this is to create a folder within your main project named `terraform-state`. An example `main.tf` to use this is as follows:

```
module "state_backend" {
  source = "github.com/tamu-edu/it-ae-tfmod-aws-state?ref=v0.0.4"

  bucket_name         = "my-terraform-state-bucket"
}
```

To execute, first obtain credentials for an AWS account with permissions to create S3 buckets and [optionally] DynamoDB tables. Then run:

```
terraform init
terraform apply
```

A common use pattern is to create a `setup` folder in your main project to create the state backend before running the rest of your terraform code. An example structure is as follows:

```
/setup/main.tf  # Code to create the state backend
/main.tf        # Your main terraform code
```

When used this way, you can write the backend configuration in your main terraform code as follows:

```
resource "local_file" "write_parent_backend_config" {
  content  = module.state_backend.terraform_backend_config
  filename = "../tf_backend.tf"
}
```

When no inputs are provided, the module will create an S3 bucket with a generated name based on the AWS account ID (`terraform-state-{account_id}`). It will not create a DynamoDB table, assuming S3 object locking will be used for state locking (as recommended by AWS and Hashicorp).

## .gitignore recommendation
Consider adding the following to your `.gitignore` file, updating paths as necessary:

```
# .tfstate files
*.tfstate
*.tfstate.*
!/setup/*.tfstate
!/setup/*.tfstate.*
```

This will allow committing the terraform state files for the setup folder while ignoring state files for the rest of your project.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.17.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_s3_bucket.state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_versioning.state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the S3 bucket to create for storing the Terraform state | `string` | `null` | no |
| <a name="input_dynamodb_table_name"></a> [dynamodb\_table\_name](#input\_dynamodb\_table\_name) | The name of the DynamoDB table to create for storing the Terraform state lock. If omitted, will autogenerate a name based on the AWS account ID. | `string` | `null` | no |
| <a name="input_use_dynamodb"></a> [use\_dynamodb](#input\_use\_dynamodb) | Whether to create a DynamoDB table for storing the Terraform state lock. If false, S3 object locking will be used. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | AWS account ID where state resources were created |
| <a name="output_bucket"></a> [bucket](#output\_bucket) | The name of the S3 bucket created for storing the Terraform state |
| <a name="output_dynamodb_table"></a> [dynamodb\_table](#output\_dynamodb\_table) | The name of the DynamoDB table created for storing the Terraform state lock, or null if not created |
| <a name="output_region"></a> [region](#output\_region) | AWS region where state resources were created |
| <a name="output_terraform_backend_config"></a> [terraform\_backend\_config](#output\_terraform\_backend\_config) | A terraform backend configuration template |
<!-- END_TF_DOCS -->