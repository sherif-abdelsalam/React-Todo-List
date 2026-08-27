provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Service     = "7bf5776c-6e63-469a-ba5c-a2ab7b7e936d"
      Environment = "dev"
      ManagedBy   = "autodeployers"
    }
  }
}
