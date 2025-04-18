terraform {
  backend "s3" {
    bucket         = "${var.bucket}"
    key            = "${var.key}"
    region         = "${var.region}"
    use_lockfile   = true
    encrypt        = true
    acl            = "bucket-owner-full-control"
  }
}