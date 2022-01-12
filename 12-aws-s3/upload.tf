resource "aws_s3_bucket_object" "upload" {
  bucket = "bucket-name"
  key = "note.txt"
  source = "note.txt" //path-file-uploaded
}