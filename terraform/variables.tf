variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for naming resources"
  type        = string
  default     = "terraform-learning"
}

variable "vpc_id" {
  description = "Existing VPC ID to import"
  type        = string
  # Obtienes esto con: aws ec2 describe-vpcs --query 'Vpcs[0].VpcId' --output text
}

variable "lambda_function_name" {
  description = "Name for the Lambda function"
  type        = string
  default     = "example-lambda"
}