terraform {
  backend "s3" {
    bucket         = "gp-test-deployhub"
    key            = "7bf5776c-6e63-469a-ba5c-a2ab7b7e936d/dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
