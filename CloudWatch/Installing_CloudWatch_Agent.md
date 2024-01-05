## Installing CloudWatch Agent
## [Download and configure the CloudWatch agent using the command] line(https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/download-cloudwatch-agent-commandline.html)

1. Download and Install CloudWatch Agent
    ```bash
    wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb

    # https://  amazoncloudwatch-agent-region.s3. region.amazonaws.com/ubuntu/amd64/   latest/amazon-cloudwatch-agent.deb
    ```

2. Install Package
    ```bash
    sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
    ```
3. Create the CloudWatch agent configuration file

    [CloudWatch agent predefined metric sets](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/metrics-collected-by-CloudWatch-agent.html)

4. Install Collected
    ```bash
     sudo apt-get update && sudo apt-get install collectd
     ```

### Run the CloudWatch agent configuration wizard
```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
```
#### Configuration file path on Linux server
```/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json```

### [Manually create or edit the CloudWatch agent configuration file](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-Configuration-File-Details.html)

The CloudWatch agent configuration file is a JSON file with four sections, `agent`, ```metrics```, ```logs```, and ```traces```

## [CloudWatch agent configuration file: Complete examples](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-Configuration-File-Details.html#CloudWatch-Agent-Configuration-File-Complete-Example)
```json
    {
      "agent": {
        "metrics_collection_interval": 10,
        "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log"
      },
      "metrics": {
        "namespace": "MyCustomNamespace",
        "metrics_collected": {
          "cpu": {
            "resources": [
              "*"
            ],
            "measurement": [
              {"name": "cpu_usage_idle", "rename": "CPU_USAGE_IDLE", "unit": "Percent"},
              {"name": "cpu_usage_nice", "unit": "Percent"},
              "cpu_usage_guest"
            ],
            "totalcpu": false,
            "metrics_collection_interval": 10,
            "append_dimensions": {
              "customized_dimension_key_1": "customized_dimension_value_1",
              "customized_dimension_key_2": "customized_dimension_value_2"
            }
          },
          "disk": {
            "resources": [
              "/",
              "/tmp"
            ],
            "measurement": [
              {"name": "free", "rename": "DISK_FREE", "unit": "Gigabytes"},
              "total",
              "used"
            ],
             "ignore_file_system_types": [
              "sysfs", "devtmpfs"
            ],
            "metrics_collection_interval": 60,
            "append_dimensions": {
              "customized_dimension_key_3": "customized_dimension_value_3",
              "customized_dimension_key_4": "customized_dimension_value_4"
            }
          },
          "diskio": {
            "resources": [
              "*"
            ],
            "measurement": [
              "reads",
              "writes",
              "read_time",
              "write_time",
              "io_time"
            ],
            "metrics_collection_interval": 60
          },
          "swap": {
            "measurement": [
              "swap_used",
              "swap_free",
              "swap_used_percent"
            ]
          },
          "mem": {
            "measurement": [
              "mem_used",
              "mem_cached",
              "mem_total"
            ],
            "metrics_collection_interval": 1
          },
          "net": {
            "resources": [
              "eth0"
            ],
            "measurement": [
              "bytes_sent",
              "bytes_recv",
              "drop_in",
              "drop_out"
            ]
          },
          "netstat": {
            "measurement": [
              "tcp_established",
              "tcp_syn_sent",
              "tcp_close"
            ],
            "metrics_collection_interval": 60
          },
          "processes": {
            "measurement": [
              "running",
              "sleeping",
              "dead"
            ]
          }
        },
        "append_dimensions": {
          "ImageId": "${aws:ImageId}",
          "InstanceId": "${aws:InstanceId}",
          "InstanceType": "${aws:InstanceType}",
          "AutoScalingGroupName": "${aws:AutoScalingGroupName}"
        },
        "aggregation_dimensions" : [["ImageId"], ["InstanceId", "InstanceType"], ["d1"],[]],
        "force_flush_interval" : 30
      },
      "logs": {
        "logs_collected": {
          "files": {
            "collect_list": [
              {
                "file_path": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log",
                "log_group_name": "amazon-cloudwatch-agent.log",
                "log_stream_name": "amazon-cloudwatch-agent.log",
                "timezone": "UTC"
              },
              {
                "file_path": "/opt/aws/amazon-cloudwatch-agent/logs/test.log",
                "log_group_name": "test.log",
                "log_stream_name": "test.log",
                "timezone": "Local"
              }
            ]
          }
        },
        "log_stream_name": "my_log_stream_name",
        "force_flush_interval" : 15,
        "metrics_collected": {
           "kubernetes": {
                "enhanced_container_insights": true
      }
    }
  }
}
```

```json
{
 "agent": {
  "metrics_collection_interval": 60,
  "run_as_user": "cwagent"
 },
 "metrics": {
  "aggregation_dimensions": [
   [
    "InstanceId"
   ]
  ],
  "metrics_collected": {
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
### Check status of agent
```bash
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
```

### To start Agent
```bash
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
# /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

```

**_By default, the active agent reports metrics from your instance to the CWAgent namespace within CloudWatch._**

## AWS Access key configuration
```bash
cat > ~/.aws/credentials
[default]
  aws_access_key_id=xxx
  aws_secret_access_key=xxxxxx
  ```

# /opt/aws/amazon-cloudwatch-agent/etc/common-config.toml
[credentials]
    shared_credential_profile = "{default}"
    shared_credential_file = "{credentials}"

## Example configuration
```json
{
   "agent": {
      "metrics_collection_interval": 60,
      "run_as_user": "root"
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
```json
{
  "metrics": {
    "append_dimensions": {
      "AutoScalingGroupName": "${aws:AutoScalingGroupName}",
      "ImageId": "${aws:ImageId}",
      "InstanceId": "${aws:InstanceId}",
      "InstanceType": "${aws:InstanceType}"
    },
    "metrics_collected": {
      "disk": {
        "measurement": [
          "used_percent"
        ],
        "resources": [
          "*"
        ],
        "ignore_file_system_types": [
          "sysfs",
          "tmpfs",
          "devtmpfs",
          "devfs"
        ]
      },
      "mem": {
        "measurement": [
          "mem_used_percent"
        ]
      },
      "cpu": {
        "measurement": [
          "cpu_usage_idle",
          "cpu_usage_iowait",
          "cpu_usage_user",
          "cpu_usage_system"
        ],
        "totalcpu": false
      },
      "swap": {
        "measurement": [
          "swap_used_percent"
        ]
      },
      "processes": {
        "measurement": [
          "cpu_usage",
          "memory_usage",
          "num_threads"
        ],
        "metrics_collection_interval": 60,
        "top_processes": 5,
        "ignore_denied_access": true
      }
    }
  }
}

```
### With custom namespace
```json
{
  "metrics": {
    "append_dimensions": {
      "AutoScalingGroupName": "${aws:AutoScalingGroupName}",
      "ImageId": "${aws:ImageId}",
      "InstanceId": "${aws:InstanceId}",
      "InstanceType": "${aws:InstanceType}"
    },
    "metrics_collected": {
      "disk": {
        "measurement": [
          "used_percent"
        ],
        "namespace": "Custom/Disk",
        "resources": [
          "*"
        ],
        "ignore_file_system_types": [
          "sysfs",
          "tmpfs",
          "devtmpfs",
          "devfs"
        ]
      },
      "mem": {
        "measurement": [
          "mem_used_percent"
        ],
        "namespace": "Custom/Memory"
      },
      "cpu": {
        "measurement": [
          "cpu_usage_idle",
          "cpu_usage_iowait",
          "cpu_usage_user",
          "cpu_usage_system"
        ],
        "totalcpu": false,
        "namespace": "Custom/CPU"
      },
      "swap": {
        "measurement": [
          "swap_used_percent"
        ],
        "namespace": "Custom/Swap"
      },
      "processes": {
        "measurement": [
          "cpu_usage",
          "memory_usage",
          "num_threads"
        ],
        "metrics_collection_interval": 60,
        "top_processes": 5,
        "ignore_denied_access": true,
        "namespace": "Custom/Processes"
      }
    }
  }
}

```
### Example 4
``` json
{
  "metrics": {
    "append_dimensions": {
      "AutoScalingGroupName": "${aws:AutoScalingGroupName}",
      "ImageId": "${aws:ImageId}",
      "InstanceId": "${aws:InstanceId}",
      "InstanceType": "${aws:InstanceType}"
    },
    "namespace": "Custom",
    "metrics_collected": {
      "disk": {
        "measurement": [
          "used_percent"
        ],
        "namespace": "Disk",
        "resources": [
          "*"
        ],
        "ignore_file_system_types": [
          "sysfs",
          "tmpfs",
          "devtmpfs",
          "devfs"
        ]
      },
      "mem": {
        "measurement": [
          "mem_used_percent"
        ],
        "namespace": "Memory"
      },
      "cpu": {
        "measurement": [
          "cpu_usage_idle",
          "cpu_usage_iowait",
          "cpu_usage_user",
          "cpu_usage_system"
        ],
        "totalcpu": false,
        "namespace": "CPU"
      },
      "swap": {
        "measurement": [
          "swap_used_percent"
        ],
        "namespace": "Swap"
      },
      "processes": {
        "measurement": [
          "cpu_usage",
          "memory_usage",
          "num_threads"
        ],
        "metrics_collection_interval": 60,
        "top_processes": 5,
        "ignore_denied_access": true,
        "namespace": "Processes"
      }
    },
    "aws_access_key_id": "YOUR_ACCESS_KEY_ID",
    "aws_secret_access_key": "YOUR_SECRET_ACCESS_KEY",
    "region": "YOUR_AWS_REGION"
  }
}
```


## Sending Custom Metrics
```bash
aws cloudwatch put-metric-data --namespace YourNamespace --metric-name YourMetricName --value 42

aws cloudwatch put-metric-data --namespace YourNamespace --metric-name YourMetricName --value 42 --dimensions DimensionName=Value --timestamp "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" --unit Count

```
## List of some commonly used units in CloudWatch:
- **Count**: The raw count of a metric.
- **Seconds**: Time-based metrics are often measured in seconds.
- **Microseconds, Milliseconds**: For more granular time measurements.
- **Bytes**: For metrics related to data size or volume.
- **Kilobytes, Megabytes, Gigabytes, Terabytes**: For larger data size metrics.
- **Bits, Kilobits, Megabits, Gigabits, Terabits**: For metrics related to network data transfer rates.
- **Percent**: For percentage metrics.
- **Count/Second, Bits/Second, Bytes/Second**: For rate-based metrics.
- **None**: When the metric is dimensionless or doesn't require a unit.

```bash
aws cloudwatch put-metric-data --namespace YourNamespace --metric-name YourMetricName \
  --value 42 --dimensions DimensionName1=Value1 DimensionName2=Value2 \
  --timestamp "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" --unit Count
```
## Send multiple metrics
```bash
aws cloudwatch put-metric-data --namespace YourNamespace \
  --metric-data MetricName=Metric1,Dimensions=[{Name=Dimension1,Value=Value1},{Name=Dimension2,Value=Value2}],Value=42,Unit=Count MetricName=Metric2,Dimensions=[{Name=Dimension3,Value=Value3}],Value=57,Unit=Count
```
## Using AWS Python SDK
```python
import boto3
from datetime import datetime

# Specify your AWS region
aws_region = 'your_aws_region'

# Create CloudWatch client
cloudwatch = boto3.client('cloudwatch', region_name=aws_region)

# Specify the namespace and metric name
namespace = 'YourNamespace'
metric_name = 'YourMetricName'

# Specify dimensions (if any)
dimensions = [
    {
        'Name': 'DimensionName1',
        'Value': 'Value1'
    },
    {
        'Name': 'DimensionName2',
        'Value': 'Value2'
    }
]

# Specify the metric value
metric_value = 42

# Specify the timestamp (optional, defaults to the current time)
timestamp = datetime.utcnow()

# Specify the unit for the metric
unit = 'Count'

# Send custom metric to CloudWatch
response = cloudwatch.put_metric_data(
    Namespace=namespace,
    MetricData=[
        {
            'MetricName': metric_name,
            'Dimensions': dimensions,
            'Value': metric_value,
            'Timestamp': timestamp,
            'Unit': unit
        }
    ]
)

# Print the response from CloudWatch (optional)
print(response)

```
### Send multiple metrics
```python
import boto3
from datetime import datetime

# Specify your AWS region
aws_region = 'your_aws_region'

# Create CloudWatch client
cloudwatch = boto3.client('cloudwatch', region_name=aws_region)

# Specify the namespace
namespace = 'YourNamespace'

# List of metrics
metrics_to_send = [
    {
        'MetricName': 'Metric1',
        'Dimensions': [
            {'Name': 'Dimension1', 'Value': 'Value1'},
            {'Name': 'Dimension2', 'Value': 'Value2'}
        ],
        'Value': 42,
        'Timestamp': datetime.utcnow(),
        'Unit': 'Count'
    },
    {
        'MetricName': 'Metric2',
        'Dimensions': [
            {'Name': 'Dimension3', 'Value': 'Value3'}
        ],
        'Value': 57,
        'Timestamp': datetime.utcnow(),
        'Unit': 'Count'
    },
    # Add more metrics as needed
]

# Send list of custom metrics to CloudWatch
response = cloudwatch.put_metric_data(
    Namespace=namespace,
    MetricData=metrics_to_send
)

# Print the response from CloudWatch (optional)
print(response)
```
## Get Metric Statistics
```bash
aws cloudwatch get-metric-statistics \
  --namespace YourNamespace \
  --metric-name YourMetricName \
  --dimensions Name=DimensionName1,Value=Value1 Name=DimensionName2,Value=Value2 \
  --start-time "$(date -u -d '30 minutes ago' '+%Y-%m-%dT%H:%M:%SZ')" \
  --end-time "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
  --period 300 \
  --statistics Average \
  --region your_aws_region
```
### Example 1
```python
import boto3
import psutil  # Make sure to install psutil library using: pip install psutil
from datetime import datetime

# Specify your AWS region
aws_region = 'your_aws_region'

# Create CloudWatch client
cloudwatch = boto3.client('cloudwatch', region_name=aws_region)

# Specify the namespace and metric name
namespace = 'CustomMetrics'
metric_name = 'SystemUserCount'

# Retrieve system user count using psutil
user_count = len(psutil.users())

# Specify dimensions (if any)
dimensions = [
    {
        'Name': 'InstanceId',  # Replace with relevant dimension name
        'Value': 'i-0123456789abcdef0'  # Replace with your instance ID or leave it as is
    }
]

# Specify the timestamp (optional, defaults to the current time)
timestamp = datetime.utcnow()

# Specify the unit for the metric
unit = 'Count'

# Send custom metric to CloudWatch
response = cloudwatch.put_metric_data(
    Namespace=namespace,
    MetricData=[
        {
            'MetricName': metric_name,
            'Dimensions': dimensions,
            'Value': user_count,
            'Timestamp': timestamp,
            'Unit': unit
        }
    ]
)

# Print the response from CloudWatch (optional)
print(response)
```

## Example 2
```python
import boto3
import subprocess
from datetime import datetime

# Specify your AWS region
aws_region = 'your_aws_region'

# Create CloudWatch client
cloudwatch = boto3.client('cloudwatch', region_name=aws_region)

# Specify the namespace and metric name
namespace = 'CustomMetrics'
metric_name = 'SystemUserCount'

# Run the shell command to get user count
user_count = int(subprocess.check_output(['cat', '/etc/passwd', '|', 'wc', '-l'], shell=True))

# Specify dimensions (if any)
dimensions = [
    {
        'Name': 'InstanceId',  # Replace with relevant dimension name
        'Value': 'i-0123456789abcdef0'  # Replace with your instance ID or leave it as is
    }
]

# Specify the timestamp (optional, defaults to the current time)
timestamp = datetime.utcnow()

# Specify the unit for the metric
unit = 'Count'

# Send custom metric to CloudWatch
response = cloudwatch.put_metric_data(
    Namespace=namespace,
    MetricData=[
        {
            'MetricName': metric_name,
            'Dimensions': dimensions,
            'Value': user_count,
            'Timestamp': timestamp,
            'Unit': unit
        }
    ]
)

# Print the response from CloudWatch (optional)
print(response)
```

