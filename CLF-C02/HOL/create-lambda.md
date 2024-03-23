# Create a Lambda Function Using the AWS Management Console
![image](../../images/CLF-CO2-lambda.jpg)
## Introduction
In this practical workshop, you will create a Lambda function utilizing the Python programming language directly within the AWS console. Additionally, you'll explore and analyze logs produced by CloudWatch as part of the exercise.

## Solution
Log in to the AWS Management Console using the credentials provided on the lab instructions page. Make sure you're using the `us-east-1` Region.

## Author Lambda Function in Python
1. Navigate to Lambda.

2. Click **Create function**.

3. Make sure the **Author from scratch** option at the top is selected, and then use the following settings:

    * **Function name**: Type _myfunction_.
    * **Runtime**: Select the latest version of Python.
4. Expand **Change default execution** role section, and verify that **Create a new role with basic Lambda permissions** is selected.

5. Click **Create function**.

6. Once the function has been created, scroll down to the **Code** tab.

7. Under **Code source**, select **lambda_function.py**.

8. Replace the existing sample code with the following:

```json
import json

def lambda_handler(event, context):
    message = 'Hello {} {}! Keep being awesome!'.format(event['first_name'], event['last_name'])  

    #print to CloudWatch logs
    print(message)

    return {
        'message' : message
    }  
```
9. Click **Deploy**.

## Create a Test Event and Execute Lambda
1. Select **Test** > **Configure test event**.

2. For **Event name**, type _mytest_.

3. In the **Event JSON** box, replace the sample code with the following:

```json
{ "first_name": "Your First Name Here", "last_name": "Your Last Name Here" }
```
4. Update the code to use your first and last name.

5. Click **Format JSON**.

6. Click **Save**.

7. Click **Test**.

8. Review the execution results that appear.

## Verify that CloudWatch has Captured Function Logs
1. Click the **Monitor** tab.
2. Click **View logs in CloudWatch**.
3. Under **Log streams**, click the most recent log stream.
4. Review the log. You should see similar output as you did in the execution results.
## Conclusion
Congratulations!