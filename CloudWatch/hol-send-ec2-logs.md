## Policy 
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
    ],
      "Resource": [
        "arn:aws:logs:*:*:*"
    ]
  }
 ]
}
```

## Example Cloud-Agent config file
```json
{
   "agent": {
      "metrics_collection_interval": 60,
      "run_as_user": "root"
   },
   "logs": {
      "logs_collected": {
       "files": {
         "collect_list": [
          {
            "file_path": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log",
            "log_group_name": "/apps/CloudWatchAgentLog/",
            "log_stream_name": "{ip_address}_{instance_id}",
            "timezone": "Local"
          },
          {
            "file_path": "/var/log/syslog",
            "log_group_name": "/apps/system/messages",
            "log_stream_name": "{ip_address}_{instance_id}",
            "timestamp_format": "%b %d %H:%M:%S",
            "timezone": "Local"
          },
          {
            "file_path": "/var/log/nginx/access.log",
            "log_group_name": "/apps/webservers/nginx/access",
            "log_stream_name": "{ip_address}_{instance_id}",
            "timestamp_format": "%d/%b/%Y:%H:%M:%S %z",
            "timezone": "Local"
          }
         ]
       }
      }
    },
   "metrics": {
      "aggregation_dimensions": [
         [
            "InstanceId"
         ]
      ],
      "append_dimensions": {
         "ImageId": "${aws:ImageId}",
         "InstanceId": "${aws:InstanceId}",
         "InstanceType": "${aws:InstanceType}"
      },
      "metrics_collected": {
         "disk": {
            "measurement": [
               "used_percent"
            ],
            "metrics_collection_interval": 60,
            "resources": [
               "/"
            ]
         },
         "mem": {
            "measurement": [
               "mem_used_percent"
            ],
            "metrics_collection_interval": 60
         }
      }
   }
}
```