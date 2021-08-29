data "archive_file" "lambda_zip_file" {
  type        = "zip"
  output_path = "main.zip"
  source_dir  = "../app"
}

data "archive_file" "lambda_info_zip_file" {
  type        = "zip"
  output_path = "main_info.zip"
  source_dir  = "../simple_response"
}

data "aws_iam_policy_document" "lambda_basic_policy" {
  statement {
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lambda_extend_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}