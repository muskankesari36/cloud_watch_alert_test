terraform {
  backend "s3" {
    bucket         = "test-state-bucket-681623867646"
    key            = "alerts/tf.state"
    region         = "us-east-1"
    dynamodb_table = "tf-state-lock"
    encrypt        = true
  }
}

provider "aws" {}