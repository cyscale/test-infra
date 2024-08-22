module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "cys-lambda-external-access"
  description   = "Lambda function with layer for testing external access"
  handler       = "function.lambda_handler"
  runtime       = "python3.12"
  publish       = true

  source_path = "./src/function.py"

  store_on_s3 = true
  s3_bucket   = aws_s3_bucket.external_access.id

  layers = [
    module.lambda_layer_s3.lambda_layer_arn,
  ]

  environment_variables = {
    Serverless = "Terraform"
  }
}

module "lambda_layer_s3" {
  source = "terraform-aws-modules/lambda/aws"

  create_layer = true

  layer_name          = "lambda-layer-s3"
  description         = "Lambda layer for testing external access"
  compatible_runtimes = ["python3.12"]

  source_path = "./src"
  store_on_s3 = true
  s3_bucket   = aws_s3_bucket.external_access.id
}

resource "aws_lambda_permission" "external_access" {
  statement_id  = "AllowExecutionFromFromManagementAccount"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function.lambda_function_name
  principal     = local.external_principal
}

resource "aws_lambda_layer_version_permission" "external_access" {
  statement_id   = "AllowLayerAccessFromManagementAccount"
  action         = "lambda:GetLayerVersion"
  principal      = local.external_principal
  layer_name     = "lambda-layer-s3"
  version_number = module.lambda_layer_s3.lambda_layer_version
}
