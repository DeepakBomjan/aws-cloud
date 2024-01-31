## Before We Begin
[Script link](https://github.com/natonic/AWS_SA_Pro/tree/master/webIdentityFederation)


## Create an EC2 Instance
To create an EC2 Instance, we need to perform the following:
Select AMI: **Amazon Linux 2 AMI**

## Authenticate User via Identity Provider
With our instance created and key pair downloaded, we need to authenticate our user via the identity provider. To do so, switch to the *Web Identity Federation * complete the following:

1. In the _Web Identity Federation Playground_ tab.
2. Click *Login with Amazon*. You may need to use your own, or a 3rd party, log in.
3. In the Response section, observe that it passes back an `access_token`.
4. Click **Proceed to Step 2**.
5. Click Call **AssumeRoleWithWebIdentity**.
6. Click **Proceed to Step 3**.
7. In the _Action_ section, by the **ListBucket** dropdown, click **Go**.
8. Now, click **ListBucket**, select **GetObject** in the dropdown, and click **Go**.
This completes the authentication process.

## Web Identity Federation in the Real World
For the next part of the lab, we will be using a terminal.

1. In the EC2 instance dashboard, click **Connect** at the top.
2. In the _Connect to Your Instance dialog_, copy the `chmod` command.
3. Open a terminal session and change to our `downloads` directory using the `cd` command, or wherever we saved our key pair.
4. Check to make sure that the file is in this directory by using `ls`.
## Install Python
To work with python, do the following:

1. Update the packages:

    ```bash
    sudo yum update
    ```
2. Check that python is downloaded to your terminal:
    ```bash
    python --version
    ```

3. Install pip:

    ```bash
    sudo yum install python-pip
    ```

4. Install Boto 3:

    ```bash
    sudo pip install boto3
    ```
    
5. Once we're in the correct directory, paste the `chmod` command you copied from the EC2 instance:

    ```bash
    chmod 400 webidfed.pem
    ```

6. Log in to the instance via SSH using the command in the *Connect to Your Instance* code provided.


## Run the Python script

Our final step is to run the python script. To do this, use the GitHub link provided with the lab credentials and complete the following:

1. Open the *originalWebFeb.py* file.

2. Select **Raw** to open the script.

3. Open your preferred text editor and paste in the Python script into the text editor:

    ```python
    import boto3

    client = boto3.client('sts')

    arn = 'arn:aws:iam:xxxxxxxxxxxx:role/WebIdFed_Amazon'
    session_name = 'web-identity-federation'
    token = '...'

    creds = client.assume_role_with_web_identity(
        RoleArn=arn,
        RoleSessionName=session_name,
        WebIdentityToken=token,
        ProviderId='www.amazon.com',
    )

    print creds['AssumedRoleUser']['Arn']
    print creds['AssumedRoleUser']['AssumedRoleId']
    ```

4. Copy your `access_token` from the Web Identity Federation Playground page, and decode it on a site like [URLdecoder.org](https://www.urldecoder.org/).
5. Copy the decoded token.
6. Return to the text editor and paste in the decoded access token to the `token` part of the Python script, which looks like this: token = `'...'`
7. Back on the *Web Identity Federation Playground* page, copy the *Role Arn*  and replace the *ARN* section with the new *Role Arn*.
8. In the terminal, create a new file:

    ```bash
    vim webfed.py
    ```

8. Paste in the updated Python script.
9. Hit **Escape** and then save and exit:

    ```bash
    :wq!
    ```

10. Make the `webfed.py` executable:

    ```bash
    chmod +x webfed.py
    ```

11. Run  the file:

    ```bash
    python webfed.py
    ```
    
The *ARN* and the `<AssumedRoleID>` from the *Response* section of the *Web Identity Federation Playground* page appear, letting us know that we've completed the lab correctly.

## Conclusion

Congratulations—you've completed the lab!