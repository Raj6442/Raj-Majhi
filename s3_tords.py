import boto3
import pandas as pd
import psycopg2
import os
import json

# Initialize clients
s3_client = boto3.client('s3')
rds_client = boto3.client('rds-data')
glue_client = boto3.client('glue')

# Constants
S3_BUCKET = 'my-s3-bucket'
S3_KEY = 'data/file.csv'
RDS_DB_NAME = 'my-rds-db'
RDS_CLUSTER_ARN = 'arn:aws:rds:us-west-2:123456789012:cluster:my-rds-cluster'
RDS_SECRET_ARN = 'arn:aws:secretsmanager:us-west-2:123456789012:secret:my-rds-secret'
GLUE_DATABASE_NAME = 'my-glue-database'

def read_s3_data():
    obj = s3_client.get_object(Bucket=S3_BUCKET, Key=S3_KEY)
    df = pd.read_csv(obj['Body'])
    return df

def push_to_rds(df):
    try:
        conn = psycopg2.connect(
            dbname=RDS_DB_NAME,
            host=os.environ.get('RDS_HOST'),
            user=os.environ.get('RDS_USER'),
            password=os.environ.get('RDS_PASSWORD'),
            port='5432'
        )
        cursor = conn.cursor()
        for index, row in df.iterrows():
            cursor.execute(f"INSERT INTO my_table (col1, col2) VALUES (%s, %s)", (row['col1'], row['col2']))
        conn.commit()
        cursor.close()
        conn.close()
        print("Data pushed to RDS successfully.")
    except Exception as e:
        print(f"Error pushing to RDS: {str(e)}")
        push_to_glue(df)

def push_to_glue(df):
    try:
        glue_client.batch_create_partition(
            DatabaseName=GLUE_DATABASE_NAME,
            TableName='my_table',
            PartitionInputList=[{
                'Values': ['partition_value'],
                'StorageDescriptor': {
                    'Columns': [{'Name': 'col1', 'Type': 'string'}, {'Name': 'col2', 'Type': 'string'}],
                    'Location': 's3://my-glue-bucket/'
                }
            }]
        )
        print("Data pushed to Glue successfully.")
    except Exception as e:
        print(f"Error pushing to Glue: {str(e)}")

def lambda_handler(event, context):
    df = read_s3_data()
    push_to_rds(df)
