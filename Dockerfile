FROM public.ecr.aws/lambda/python:3.9

COPY s3_to_rds.py /var/task/
COPY requirements.txt /var/task/

WORKDIR /var/task

RUN pip install -r requirements.txt

CMD ["s3_to_rds.lambda_handler"]
FROM public.ecr.aws/lambda/python:3.9

COPY s3_tords.py /var/task/
COPY requirements.txt /var/task/

WORKDIR /var/task

RUN pip install -r requirements.txt

CMD ["s3_to_rds.lambda_handler"]
