## Configuring a Custom Domain with Cognito
Description
In this hands-on lab, you will configure a number of AWS services, such as Cognito, AWS Certificate Manager (ACM), S3, and Route 53, in order to configure a custom domain for use with Cognito's hosted UI. Let's take a look at the diagram and our sample application to understand our scenario and goals for the lab a little better.

Objectives
Successfully complete this lab by achieving the following learning objectives:

Objective 1: Create a Cognito User Pool

Create a user pool named CognitoLab:
Review defaults.
Note the Pool Id.
Add an app client named CognitoLabApp:
Uncheck Generate client secret:
It's not needed for this flow. User pool apps with a client secret are not supported by the JavaScript SDK.
Note the App client id.
Objective 2: Create an ACM Certificate

Provision certificates.
Create a public certification.
Specify a wildcard certificate (to catch both auth. and www.).
Use the DNS validation method.
Expand status for domain:
Click Create record in Route 53.
Click Continue.
Refresh until Pending validation becomes Issued (about 3 minutes).
Objective 3: Configure a Custom Domain for Cognito

Navigate to the user pool.
Under App integration, select Domain name.
Choose Use your domain.
Use auth.<labdomain> (where <labdomain> is what was assigned to the lab).
Select the ACM certificate.
Click Save changes.
Note the Alias target.
Wait for the CREATING status to become ACTIVE (about 15 minutes).
Objective 4: Complete App Client Configuration and Create CloudFront Distribution

In Route 53, create an A record for subdomain auth.
Use ALIAS to point to the CloudFront alias target from Cognito App Client.
Go to Cognito > App Integration > App client settings:
Enabled Identity Providers:

Provide the Callback URL (https://www.<labdomain>).
Provide the Sign out URL (https://www.<labdomain>).
Check Authorization code grant.
Select email, openid, and profile scopes.
Save changes.
Go to CloudFront:
Origin Domain Name is www.<labdomain> bucket.
Viewer Protocol Policy is Redirect HTTP to HTTPS
In Distribution Settings:
Alternate domain names: www.<labdomain>
Custom SSL Certificate Use the wildcard certificate, *.<labdomain>
Default Root Object: index.html (because S3's index.html doesn't work behind CloudFront)
Click Create Distribution.
Wait for the In Progress status to become Deployed.
Note the distribution domain name (e.g., d3XXXXXXXXXXX.cloudfront.net)
Go to Route 53
Create record set:
Set the www.<labdomain> CNAME so that it aliases to the CloudFront distribution name from the previous step.
Objective 5: Configure, Deploy, and Test the Application

After logging in to the provided EC2 instance (via SSH):

git clone https://github.com/linuxacademy/content-aws-sam
cd content-aws-sam/labs/Configuring-Custom-Domain-Cognito/app
npm install
cd src
vim main.js
Fill in the user pool id, app client id, domain, and redirect URLs.
Save and quit.
cd ..
npm run build
cd dist
aws s3 sync . s3://www.<labdomain>
Browse to https://www.<labdomain>
Sign up.
Enter the confirmation code received via email.
Note that you are now signed in with your username.

https://learn.acloud.guru/handson/0b77909a-2844-461f-b865-60229e614ad4
