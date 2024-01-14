## HOL References
1. [todo-app-ecs-aws](https://github.com/hpfpv/todo-app-ecs-aws)
2. https://github.com/aws-samples/chalice-workshop/tree/master?tab=readme-ov-file
3. [AWS Three Tier Web Architecture](https://github.com/iamtejasmane/aws-three-tier-web-app)
4. [Full stack ToDo List](https://github.com/AndyW22/todolist-app)
5. [A Serverless Todo application](https://github.com/pmuens/serverless-book/blob/master/06-serverless-by-example/02-a-serverless-todo-application.md)
6. [Deploy a Container Web App on Amazon ECS Using Amazon CodeCatalyst](https://community.aws/tutorials/deploy-webapp-ecs-codecatalyst)
7. https://github.com/LondheShubham153/node-todo-cicd
8. https://github.com/Shubhamdhiyani/node-todo-cicd

## Tutorial
1. Clone the sample app
```bash
git clone https://github.com/build-on-aws/automate-web-app-amazon-ecs-cdk-codecatalyst.git
```

## Tutorial to dockerize sample Flask application
### Sample code
```bash

import os
import logging

from flask import Flask

app = Flask(__name__)

# various Flask explanations available at:
# https://flask.palletsprojects.com/en/1.1.x/quickstart/

@app.route('/')
# A Hello World message to show that at least something is working
def hello():
    return 'Hello World!'

@app.route('/warmup')
# A Hello World message to show that at least something is working
def warmup():
    return 'Started the resources'

@app.route('/status')
# A Hello World message to show that at least something is working
def status():
    return 'Infra is ready'

@app.errorhandler(500)
# A small bit of error handling
def server_error(e):
    logging.exception('ERROR!')
    return """
    An  error occurred: <pre>{}</pre>
    """.format(e), 500

if __name__ == '__main__':
    # Entry point for running on the local machine
    # On GAE, endpoints (e.g. /) would be called.
    # Called as: gunicorn -b :$PORT index:app,
    # host is localhost; port is 8080; this file is index (.py)
    app.run(host='127.0.0.1', port=8080, debug=True)
```
### requirements.txt
```bash
Flask==2.0.3
gunicorn==20.1.0
boto3==1.21.4
jinja2==3.0.3
werkzeug==2.0.3
itsdangerous==2.0.1
```

### Dockerfile
```bash
# Use an official Python runtime as a parent image
FROM python:3.8-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variable
ENV NAME World

# Run your_filename.py when the container launches
CMD ["python", "index.py"]

```

### Build docker image
```bash
docker build -t flask-app .
```

### Run Docker container
```bash
docker run -p 8080:8080 flask-app

```

## Using docker compose

```bash
version: '3'
services:
  my-python-app:
    build: .
    image: my-python-app:latest
    container_name: my-python-container
    ports:
      - "8080:8080"
    environment:
      - NAME=World

```
## Commands
```bash
docker-compose build
docker-compose up
```
