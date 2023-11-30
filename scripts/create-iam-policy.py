import boto3
import json

# AWS IAM policy details
policy_name = "ExamplePolicy1"

# Example policy document (replace with your actual policy)
policy_document = {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::example-bucket"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::example-bucket/*"
        }
    ]
}

# Create IAM client
iam = boto3.client('iam')

# Create IAM policy
try:
    response = iam.create_policy(
        PolicyName=policy_name,
        PolicyDocument=json.dumps(policy_document)
    )

    # Display policy ARN
    print("Policy created with ARN:", response['Policy']['Arn'])

except Exception as e:
    print("Error creating policy:", e)
