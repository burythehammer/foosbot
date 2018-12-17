resource "aws_s3_bucket" "result_bucket" {
  bucket = "foosbot-bucket-${var.env}"
  acl = "private"

  tags {
    Name = "Foosbot bucket for storing results"
  }
}

output "result_bucket_name" {
  value = "${aws_s3_bucket.result_bucket.bucket}"
}