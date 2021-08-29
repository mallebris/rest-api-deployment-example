variable "project" {
  type        = string
  description = "Project name."
}

variable "application" {
  type        = string
  description = "Application name to deploy"
}

variable "post_lambda" {
  type        = string
  description = "ARN for lambda that will response on a post requests"
}

variable "get_lambda" {
  type        = string
  description = "ARN for lambda that will response on a get requests"
}