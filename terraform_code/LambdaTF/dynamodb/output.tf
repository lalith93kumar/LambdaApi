output "vehicleDynamodbTableArn" {
  value = aws_dynamodb_table.VehicleData.arn
  description = "VPC ID"
}