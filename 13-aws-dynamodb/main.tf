resource "aws_dynamodb_table" "cars" {
  name = "cars"
  hash_key = "VIN"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "VIN"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "car-items" {
  table_name = aws_dynamodb_table.cars.name
  hash_key = aws_dynamodb_table.cars.hash_key
  item = <<EOF
    {
      "Manufacturer": {"S": "Toyota"},
      "Make": {"S": "Corolla"},
      "Year": {"N": "2008"},
      "VIN": {"S": "4EAVD5524523AEA"},
    }
  EOF
}