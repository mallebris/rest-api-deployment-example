resource "aws_iam_role" "lambda_role" {
  name               = "${var.project}-basic-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_basic_policy.json

  tags = local.tags
}

resource "aws_iam_role_policy" "lambda_policy" {
  name   = "${var.project}-basic-policy"
  role   = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lambda_extend_policy.json
}

resource "aws_lambda_function" "application" {
  filename         = data.archive_file.lambda_zip_file.output_path
  source_code_hash = data.archive_file.lambda_zip_file.output_base64sha256
  runtime          = "python3.9"
  function_name    = var.project
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_string_replace.lambda_handler"

  tags = local.tags
}

