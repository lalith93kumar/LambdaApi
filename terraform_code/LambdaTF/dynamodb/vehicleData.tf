resource "aws_dynamodb_table" "VehicleData" {
  name           = "VehicleData"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "vehicle_id"
    type = "S"
  }

  hash_key = "vehicle_id"

  tags = {
    Name        = "VehicleData"
    Environment = "Production"
  }
}