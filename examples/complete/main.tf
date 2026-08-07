module "this" {
  source = "../../"

  name                    = "cloud-custodian-example"
  create_iam_user         = false
  create_iam_role         = false
  create_lambda_role      = false
  s3_delete_objects_after = 30
  tags = {
    Example = "complete"
  }
}
