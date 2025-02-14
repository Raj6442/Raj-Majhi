# Create an ECR Repository
resource "aws_ecr_repository" "repository" {
  name = "s3-to-rds-repo"
}

# Create an RDS Aurora PostgreSQL Cluster
resource "aws_rds_cluster" "rds" {
  cluster_identifier      = "my-rds-cluster"
  master_username         = "raj_rds_user"
  master_password         = "MySecurePassw0rd"
  engine                  = "aurora-postgresql"
  engine_version          = "13.9"
  database_name           = "mydatabase"
  

  skip_final_snapshot = true

  storage_encrypted = true
  apply_immediately = true
}


# Create a Lambda Function for S3 to RDS
resource "aws_lambda_function" "s3_to_rds_lambda" {
  filename         = "lambda.zip"
  function_name    = "s3-to-rds-lambda"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "s3_to_rds.lambda_handler"
  runtime          = "python3.9"
  memory_size      = 128
  timeout          = 60

  environment {
    variables = {
      RDS_HOST     = aws_rds_cluster.rds.endpoint
      RDS_USER     = "raj_rds_user"
      RDS_PASSWORD = "MySecureP@ssw0rd"
    }
  }

  source_code_hash = filebase64sha256("lambda.zip")
}

# IAM Role for Lambda Execution
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

# Attach IAM Policy for Lambda
resource "aws_iam_policy_attachment" "lambda_rds_policy" {
  name       = "lambda_rds_policy"
  roles      = [aws_iam_role.lambda_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Output RDS Endpoint
output "lambda_function_name" {
  value = aws_lambda_function.s3_to_rds_lambda.function_name
}


# Output Lambda Function Name
output "lambda_function_name" {
  value = aws_lambda_function.s3_to_rds_lambda.function_name
}
