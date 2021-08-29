module "lambda" {
  source      = "./lambda"
  project     = "terraform-tnml"
  application = "string-replacer"
}

module "rest_api_gateway" {
  source      = "./api-gateway"
  project     = "rest-api"
  application = "tmnl"
  get_lambda  = module.lambda.lambda_info_arn
  post_lambda = module.lambda.lambda_arn

  post_lambda_name = module.lambda.lambda_name
  get_lambda_name  = module.lambda.lambda_info_name
}