pipeline {
    agent any

    environment {
        AWS_REGION = "ap-southeast-2"
        AWS_ACCOUNT_ID = "084375557233"
        ECR_REPOSITORY = "s3-to-rds-repo"
        ECR_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}"
        S3_BUCKET = "raj-s3-to-rds-bucket"
        RDS_HOST = "my-rds-cluster.cluster-cd0246wo8ikw.ap-southeast-2.rds.amazonaws.com"
        RDS_USER = "raj_rds_user"
        RDS_PASSWORD = "MySecurePass123!"
        RDS_DATABASE = "s3rdsdb"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Raj6442/Raj-Majhi.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    bat 'dir'  // Debugging: List files in workspace (Windows)
                    bat 'docker build -t s3-to-rds .'  // Use 'bat' on Windows for Docker
                    bat 'docker tag s3-to-rds:latest ${ECR_URI}:latest'
                }
            }
        }

        stage('Build Docker Image') {
    steps {
        script {
            powershell 'docker --version'  // Check Docker version
            powershell 'docker build -t s3-to-rds .'  // Build Docker image
            powershell 'docker tag s3-to-rds:latest ${ECR_URI}:latest'
        }
    }
}


        stage('Deploy Lambda via Terraform') {
            steps {
                bat 'cd terraform && terraform init && terraform apply -auto-approve'
            }
        }
    }
}
