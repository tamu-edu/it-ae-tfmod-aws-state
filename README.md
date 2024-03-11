# it-ae-tfmod-aws-state
This is a terraform module for initializing a terraform state backend in AWS. 

## Example usage

A common pattern for using this is to create a folder within your main project named `terraform-state`. An example `main.tf` to use this is as follows:

```
module "state_backend" {
  source = "github.com/tamu-edu/it-ae-tfmod-aws-state?ref=v0.0.2"
}

output "account_id" {
  value = module.state_backend.account_id
}

output "backend_config" {
  value = <<BACKENDCONFIG
  backend "s3" {
    region         = "${module.state_backend.region}"
    bucket         = "${module.state_backend.bucket}"
    key            = "terraform-state/main.tfstate"
    dynamodb_table = "${module.state_backend.dynamodb_table}"
  }
  BACKENDCONFIG
}
```

To execute, first you must login to the appropriate account. If on a Mac, it is recommended to use [granted](https://www.granted.dev/). Otherwise, you can use the AWS CLI. In any case, once logged in, run command `terraform init` in the folder where you have referenced the module. Then, run `terraform plan` to see what will be created. If satisfied with the results, run command `terraform apply`. This will create the appropriate S3 bucket and DynamoDB entries for holding state files for the main project. The state file for this will be stored on the file system. Be sure to capture the results of the output and copy it into your main Terraform stack. It is recommended to  alter the name of the key to fit the granularity of separation of concerns that you require.

Consider adding the following to your `.gitignore` file

```
# .tfstate files
*.tfstate
*.tfstate.*
!terraform-state/*.tfstate
!terraform-state/*.tfstate.*
```

This will allow committing the actual .tfstate file but only for the state storage bucket.

It creates an S3 bucket and a dynamodb table named `terraform-state-{account_id}` by default, which can be customized with inputs. 

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

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
| <a name="input_dynamodb_table_name"></a> [dynamodb\_table\_name](#input\_dynamodb\_table\_name) | The name of the DynamoDB table to create for storing the Terraform state lock | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | n/a |
| <a name="output_bucket"></a> [bucket](#output\_bucket) | n/a |
| <a name="output_dynamodb_table"></a> [dynamodb\_table](#output\_dynamodb\_table) | n/a |
| <a name="output_region"></a> [region](#output\_region) | n/a |
<!-- END_TF_DOCS -->