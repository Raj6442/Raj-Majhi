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
                    // Use shell commands to check Docker version and build the image
                    sh 'docker --version'  // Check Docker version
                    sh 'docker build -t s3-to-rds .'  // Build Docker image
                    sh 'docker tag s3-to-rds:latest ${ECR_URI}:latest'  // Tag the image
                }
            }
        }

        stage('Push Image to ECR') {
    steps {
        withAWS(credentials: 'AKIARHJJM2RY744USUZ6', region: 'ap-southeast-2') {
            sh 'aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin 084375557233.dkr.ecr.ap-southeast-2.amazonaws.com'
            sh 'docker push ${ECR_URI}:latest'
        }
    }
}


        stage('Deploy Lambda via Terraform') {
            steps {
                sh 'cd terraform && terraform init && terraform apply -auto-approve'  // Run Terraform
            }
        }
    }
}

