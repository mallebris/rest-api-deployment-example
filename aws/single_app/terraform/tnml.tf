module "lambda" {
  source      = "./lambda"
  project     = "terraform-tnml"
  application = "string-replacer"
}