terraform {
  backend "s3" {
    bucket         = "infra-automation-app"
    key            = "959ef524-0321-446a-b638-4263e657414a/dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
