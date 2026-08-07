mock_provider "aws" {}

run "contract" {
  command = plan

  variables {
    name                    = "cloud-custodian-test"
    create_iam_user         = false
    create_iam_role         = false
    create_lambda_role      = false
    s3_delete_objects_after = 30
  }

}
