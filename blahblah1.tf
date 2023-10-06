locals {
  splunk_index = var.environment == "production" ?
    var.aws_region == "us-west-2" ? "us_west_production" :
    var.aws_region == "eu-central-1" ? "eu_central_production" :
    "default_index_name"
}

locals {
  development_regions = ["us-west-2", "eu-central-1"]
  development_index = contains(local.development_regions, var.aws_region) && var.environment != "production" ? "us_west_development" : "default_index_name"
}

resource "aws_lambda_function" "example_lambda" {
  # Other Lambda function configurations go here

  environment {
    variables = {
      AWS_REGION = var.aws_region,
      SPLUNK_INDEX = local.splunk_index != "default_index_name" ? local.splunk_index : local.development_index
    }
  }

  # Other Lambda function attributes go here
}
