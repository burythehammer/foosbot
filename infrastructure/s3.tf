# Specify the provider and access details

resource "aws_s3_bucket" "result-bucket" {
  bucket = "foosbot-bucket-matt-testing2"
  acl = "private"

  tags {
    Name = "Foosbot bucket for storing results"
  }
}