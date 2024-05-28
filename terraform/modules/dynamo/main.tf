resource "aws_dynamodb_table" "table" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "N"
  }

  attribute {
    name = "body"
    type = "S"
  }

  attribute {
    name = "title"
    type = "S"
  }

  global_secondary_index {
    name               = "BodyTitleIndex"
    hash_key           = "body"
    range_key          = "title"
    projection_type    = "ALL"
    write_capacity     = 5
    read_capacity      = 5
  }
}
