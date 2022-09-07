resource "aws_dynamodb_table" "cloudfeeds_table" {
  name           = var.table_name
  hash_key       = var.table_hash_key
  range_key      = var.table_range_key
  billing_mode   = var.table_billing_mode
  read_capacity  = var.table_rcu
  write_capacity = var.table_wcu
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  
  attribute {
    name = "serviceCode"
    type = "S"
  }

  attribute {
    name = "entryId"
    type = "S"
  }
  attribute {
    name = "dateLastUpdated"
    type = "S"
  }
  attribute {
    name = "feed"
    type = "S"
  }

  ttl {
    attribute_name = "expiryTime"
    enabled        = true
  }

  local_secondary_index {
    name               = var.lsi_name
#    hash_key           = var.lsi_hash_key
    range_key          = var.lsi_range_key
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = var.gsi_name
    hash_key           = var.gsi_hash_key
#   range_key          = var.gsi_range_key
    projection_type    = "ALL"
    write_capacity     = var.gsi_wcu
    read_capacity      = var.gsi_rcu
  }

  tags = {
    Name = var.table_name
  }
}