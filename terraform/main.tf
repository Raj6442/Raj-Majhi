resource "aws_ecr_repository" "repository" {
  name = "s3-to-rds-repo"
}

resource "aws_rds_cluster" "rds" {
  cluster_identifier = "my-rds-cluster"
  master_username    = "my-rds-username"
  master_password    = "my-rds-password"
  engine             = "aurora-postgresql"
}

resource "aws_lambda_function" "s3_to_rds_lambda" {
  filename         = "lambda.zip"
  function_name    = "s3-to-rds-lambda"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "s3_to_rds.lambda_handler"
  runtime          = "python3.8"
  memory_size      = 128
  timeout          = 60

  environment {
    variables = {
      RDS_HOST     = "my-rds-host"
      RDS_USER     = "my-rds-username"
      RDS_PASSWORD = "my-rds-password"
    }
  }

  source_code_hash = filebase64sha256("lambda.zip")
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}
