output "vehicleDynamodbTableArn" {
  value = aws_dynamodb_table.VehicleData.arn
  description = "Dynamodb Table ARN"
}