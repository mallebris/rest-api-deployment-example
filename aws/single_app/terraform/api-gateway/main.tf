resource "aws_api_gateway_rest_api" "rest_api" {
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = var.project
      version = "1.0"
    }
    paths = {
      "/" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "POST"
            payloadFormatVersion = "1.0"
            type                 = "aws"
            uri                  = var.get_lambda
            passthroughBehavior  = "when_no_match"
            contentHandling      = "CONVERT_TO_TEXT"
          },
          responses = {
            "200" = {
              description = "200 response"
              content = {
                "application/json" = {
                  "schema" : {
                    "$ref" : "#/components/schemas/Empty"
                  }
                }
              }
            }
          }

        },
        post = {
          x-amazon-apigateway-integration = {
            httpMethod           = "POST"
            payloadFormatVersion = "1.0"
            type                 = "aws"
            uri                  = var.post_lambda
            passthroughBehavior  = "when_no_match"
            contentHandling      = "CONVERT_TO_TEXT"
          },
          responses = {
            "200" = {
              description = "200 response"
              content = {
                "application/json" = {
                  "schema" = {
                    "$ref" = "#/components/schemas/Empty"
                  }
                }
              }
            }
          }

        }
      }
    }
  })

  name = var.project
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_model" "error_model" {
  rest_api_id  = aws_api_gateway_rest_api.rest_api.id
  name         = "Error"
  description  = "a JSON schema"
  content_type = "application/json"

  schema = <<EOF
{
  "$schema" : "http://json-schema.org/draft-04/schema#",
  "title" : "Error Schema",
  "type" : "object",
  "properties" : {
    "message" : { "type" : "string" }
  }
}
EOF
}

resource "aws_api_gateway_model" "empty_model" {
  rest_api_id  = aws_api_gateway_rest_api.rest_api.id
  name         = "Empty"
  description  = "a JSON schema"
  content_type = "application/json"

  schema = <<EOF
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title" : "Empty Schema",
  "type" : "object"
}
EOF
}

resource "aws_api_gateway_deployment" "rest_api" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.rest_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "rest_api" {
  deployment_id = aws_api_gateway_deployment.rest_api.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = "rest_api"
}

resource "aws_lambda_permission" "lambda_info_permission" {
  statement_id  = "AllowAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.get_lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "lambda_post_permission" {
  statement_id  = "AllowAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.post_lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*/*"
}