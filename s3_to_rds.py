import boto3
import psycopg2
import json
import os

AWS_REGION = "ap-southeast-2"
S3_BUCKET = "raj-s3-to-rds-bucket"
RDS_HOST = "my-rds-cluster.cluster-cd0246wo8ikw.ap-southeast-2.rds.amazonaws.com"
RDS_PORT = "5432"
RDS_USER = "raj_rds_user"
RDS_PASSWORD = "MySecurePass123!"
RDS_DATABASE = "s3rdsdb"

def read_from_s3():
    s3 = boto3.client('s3', region_name=AWS_REGION)
    response = s3.list_objects_v2(Bucket=S3_BUCKET)

    for obj in response.get('Contents', []):
        file_data = s3.get_object(Bucket=S3_BUCKET, Key=obj['Key'])
        content = file_data['Body'].read().decode('utf-8')
        store_to_rds(content)

def store_to_rds(data):
    try:
        conn = psycopg2.connect(
            dbname=RDS_DATABASE,
            user=RDS_USER,
            password=RDS_PASSWORD,
            host=RDS_HOST,
            port=RDS_PORT
        )
        cursor = conn.cursor()
        cursor.execute("INSERT INTO records (data) VALUES (%s)", (data,))
        conn.commit()
        cursor.close()
        conn.close()
        print("Data inserted into RDS successfully.")
    except Exception as e:
        print(f"Failed to insert data into RDS: {e}")

def lambda_handler(event, context):
    read_from_s3()
    return {"statusCode": 200, "body": json.dumps("Lambda executed successfully")}
