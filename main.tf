variable "profile" {
  type    = string
  default = "default"
}

variable "region" {
  type    = string
  default = "sa-east-1"
}

locals {
  application = "Terraform Monorepo"
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

terraform {
  backend "s3" {
    profile = "default"
  }
}

module "first_service_hello_lambda" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "first-service-handler-hello"
  handler       = "index.handler"
  runtime       = "nodejs22.x"

  source_path = ".webpack/first-service-handler-hello"

  publish = true

  tags = {
    Application = local.application
  }

  allowed_triggers = {
    APIGatewayAny = {
      service    = "apigateway"
      source_arn = "${module.first_service_api_gateway.api_execution_arn}/*/*/*"
    }
  }
}

module "second_service_hello_lambda" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "second-service-handler-hello"
  handler       = "index.handler"
  runtime       = "nodejs22.x"

  source_path = ".webpack/second-service-handler-hello"

  publish = true

  tags = {
    Application = local.application
  }

  allowed_triggers = {
    APIGatewayAny = {
      service    = "apigateway"
      source_arn = "${module.second_service_api_gateway.api_execution_arn}/*/*/*"
    }
  }
}

module "lambda_cleanup" {
  source               = "./infra/lambda-version-cleanup"
  for_each             = tomap({ first_service_hello_lambda = module.first_service_hello_lambda })
  lambda_function_name = each.value.lambda_function_name
  lambda_version       = each.value.lambda_function_version
  region               = var.region
  profile              = var.profile
  depends_on           = [module.first_service_hello_lambda]
}

module "first_service_api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name                         = "first-service-api"
  protocol_type                = "HTTP"
  disable_execute_api_endpoint = false
  create_domain_name           = false
  create_domain_records        = false

  routes = {
    "GET /" = {
      integration = {
        uri                    = module.first_service_hello_lambda.lambda_function_arn
        payload_format_version = "2.0"
        timeout_milliseconds   = 6000
      }
    }
  }

  tags = {
    Application = local.application
    Terraform   = "true"
  }
}

module "second_service_api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name                         = "second-service-api"
  protocol_type                = "HTTP"
  disable_execute_api_endpoint = false
  create_domain_name           = false
  create_domain_records        = false

  routes = {
    "GET /" = {
      integration = {
        uri                    = module.second_service_hello_lambda.lambda_function_arn
        payload_format_version = "2.0"
        timeout_milliseconds   = 6000
      }
    }
  }

  tags = {
    Application = local.application
    Terraform   = "true"
  }
}

output "first_service_api_gateway_endpoint" {
  description = "First Service API Gateway endpoint"
  value       = module.first_service_api_gateway.api_endpoint
}


output "second_service_api_gateway_endpoint" {
  description = "Second Service API Gateway endpoint"
  value       = module.second_service_api_gateway.api_endpoint
}
