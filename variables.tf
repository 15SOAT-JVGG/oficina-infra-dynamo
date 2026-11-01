variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "environment" {
  type = string
  validation {
    condition     = contains(["homolog", "production"], var.environment)
    error_message = "O ambiente deve ser homolog ou production."
  }
}
