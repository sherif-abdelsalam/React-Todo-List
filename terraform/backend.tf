terraform {
  backend "s3" {
    bucket         = "infra-automation-app"
    key            = "12310e71-0351-4e1d-a822-8e90db8812e6/dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
