variable "config" {
  description = "Path to AWS config file"
  type        = list(string)
}

variable "credentials" {
  description = "Path to AWS credentials file"
  type        = list(string)
}

variable "profile" {
  description = "Name of AWS credentials profile"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "account" {
  description = "AWS account"
  type        = string
}

variable "distribution" {
  description = "CloudFront distribution ID"
  type        = string
}

variable "build_project" {
  description = "Name of the CodeBuild project for the website"
  type        = string
}

variable "invalidation_build_project" {
  description = "Name of the CodeBuild project to clear the CloudFront cache"
  type        = string
}

variable "repository" {
  description = "Name of the GitHub repository (org/repo)"
  type        = string
}

variable "codestar" {
  description = "Name of the CodeStar connection"
  type        = string
}

variable "bucket" {
  description = "Name of the S3 bucket for the website"
  type        = string
}