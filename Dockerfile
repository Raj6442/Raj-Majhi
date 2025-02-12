FROM python:3.8-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy Python script
COPY s3_to_rds.py .

# Environment variables
ENV RDS_HOST=my-rds-hostname
ENV RDS_USER=my-rds-username
ENV RDS_PASSWORD=my-rds-password

CMD ["python", "s3_to_rds.py"]
