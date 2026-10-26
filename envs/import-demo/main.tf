resource "aws_s3_bucket" "imported" {
  bucket = "jb-import-demo-aps1-d14j2"

  tags = {
    Name    = "jb-import-demo"
    Project = "project6"
  }
}
