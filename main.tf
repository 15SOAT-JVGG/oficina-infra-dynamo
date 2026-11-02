resource "aws_dynamodb_table" "stock" {
  name         = "oficina-execution-stock-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "partId"
  attribute {
    name = "partId"
    type = "S"
  }
  point_in_time_recovery { enabled = var.environment == "production" }
  deletion_protection_enabled = var.environment == "production"
}
