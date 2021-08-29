output "lambda_arn" {
  value = aws_lambda_function.application.invoke_arn
}

output "lambda_info_arn" {
  value = aws_lambda_function.application_info.invoke_arn
}

output "lambda_name" {
  value = var.project
}

output "lambda_info_name" {
  value = "${var.project}_info"
}