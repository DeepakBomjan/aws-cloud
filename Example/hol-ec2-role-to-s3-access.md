## Allow EC2 instances write access to S3 buckets in AMS accounts

1. Create EC2 Instance
2. Create EC2 instance role to allow S3 write access
3. Attach Role to EC2 Instance
4. Create Bucket and Attache below policy
```
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "<EC2-Role-ARN>"
        },
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::<Bucket-Name>/*"
      }
    ]
  }
  ```

  ETYga^TP]j1d642_lkY!
  https://176556394813.signin.aws.amazon.com/console?region=us-east-1
  AKIASSG4UZE6TD6HFJUU
  bJNgtFtM0iSauVSTu9CEvUZv9X1sN8d9n2gaBc9j
  