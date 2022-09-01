variable "table_name" {
  description = "Dynamodb table name"
  type        = string 
  default     = "entries"
}

variable "table_hash_key" {
  type        = string
  description = "DynamoDB table hash key"
  default     = "serviceCode"
}

variable "table_range_key" {
  type        = string
  default     = "entryId"
  description = "DynamoDB table range key"
}

variable "table_billing_mode" {
  type        = string
  default     = "PROVISIONED"
  description = "Table billing mode"
}

variable "table_rcu" {
  type        = number
  default     = 1
  description = "Read capacity units configuration"
}

variable "table_wcu" {
  type        = number
  default     = 1
  description = "Write capacity units configuration"
}

variable "lsi_name" {
  description = "Local Secondary Index name"
  type        = string 
  default     = "serviceCode-dateLastUpdated-index"
}

variable "lsi_hash_key" {
  type        = string
  description = "Local Secondary Index hash key"
  default     = "entryId"
}

variable "lsi_range_key" {
  type        = string
  default     = "dateLastUpdated"
  description = "Local Secondary Index range key"
}

variable "gsi_name" {
  description = "Global Secondary Index name"
  type        = string 
  default     = "global-feed-index"
}

variable "gsi_hash_key" {
  type        = string
  description = "Global Secondary Index hash key"
  default     = "feed"
}

variable "gsi_wcu" {
  type        = number
  default     = 1
  description = "Write capacity units configuration for GSI"
}

variable "gsi_rcu" {
  type        = number
  default     = 1
  description = "Read capacity units configuration for GSI"
}

/*variable "gsi_range_key" {
  type        = string
  default     = "dateLastUpdated"
  description = "Global Secondary Index range Key"
}*/
