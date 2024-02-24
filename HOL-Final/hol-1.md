# Hosting a Wordpress Application on ECS Fargate with RDS, Parameter Store, and Secrets Manager

![image](../images/HOL-Hosting_a%20_Wordpress_Application_on_ECS_Fargate_with_RDS_DB_and_Parameter_Store_.png)
## Introduction
In this practical workshop, you'll delve into deploying a WordPress application leveraging various AWS services such as Amazon RDS, AWS Systems Manager, Parameter Store, Amazon ECS, Amazon ECR, and Application Load Balancers.

### Create Infrastructure
Before you begin, please create  below resources exist.

| Type                      | Name                       |
|---------------------------|----------------------------|
| Application Load Balancer | OurApplicationLoadBalancer |
| Security Group            | ALBAllowHttp               |
| Cloud9 Environment        | OurCloud9Environment       |
| IAM Role                  | OurEcsTaskExecutionRole    |
| IAM Role                  | OurEcsTaskRole             |

### Create Database Subnet Group
First, we need to create our custom subnet group to host our DB instance.

1. Navigate to the **Amazon RDS** service.
2. Find and select **Subnet groups** from the menu.
3. click **Create DB subnet group**.
4. Name it `database-subnet-group`.
5. Enter the description of your choosing.
6. Choose the **Your Custom VPC** for the _VPC_ options.
7. Move to the _Add subnets_ section.
8. Under _Availability Zones_, select **us-east-1a**, **us-east-1b**, and **us-east-1c**.
9. For Subnets, select the subnets with the CIDRs of `10.0.20.0/24`, `10.0.21.0/24`, and `10.0.22.0/24`.
10. Click on **Create**.

## Create the Amazon RDS Instance
Now, we can create our RDS instance.

1. Navigate to the **Amazon RDS** service.

2. Under _Databases_ find and select **Create database**.

3. Select **MySQL** from the list of engine types.

4. Leave the default _Edition_ selected, which should be **MySQL Community**.

5. For _Engine version_ the latest version should populate by default.

6. Under _Templates_ select **Free Tier**.

7. Move to the _Settings_ section. For _DB cluster identifier_, change the name to `wordpress`.

8. Leave the _Master username_ set to `admin`.

9. Check the box for the option to **Manage master credentials in AWS Secrets Manager**.

10. Leave the default encryption key for the Secrets Manager credentials.

11. Move to the _Instance configuration section_. For _DB instance class, under Burstable classes_ select **db.t4g.micro**.

12. For the _Storage_ section, set the _Storage type_ to **General Purpose SSD (gp3)**.

13. Set the allocate storage to `20 GiB`.

14. Under the _Connectivity_ section, select **Don’t connect to an EC2 compute resource**.

15. Place the database in the VPC titled **Your Custom VPC** (_Do not use the default VPC!_)

16. Choose the **database subnet group** from the _DB subnet group_ dropdown.

17. Set _Public_ access to **No**.

18. For _VPC security group (firewall)_ select **Create new**, name it `database-sg`, and then select **No preference** for _Availability Zone_.

19. Skip down to the _Additional_ _configuration_ dropdown menu near the bottom of the page.

20. Within the _Database options_ set the _Initial database name_ to `wordpress`.

21. Leave the rest of the options set to the defaults.

22. Find and select **Create database**. Creation of the DB cluster could take several minutes. While you wait for this to become available, you need to edit the Security Group.

23. Navigate to the **Amazon EC2** console in a new tab.

24. Find and select the **Security Groups** menu.

25. Create `database-sg` Security Group.

26. Select _Inbound rules_ and then click **Edit inbound rules**.

27. Allow port `3306`
28. Click **Save rules**.

## Create the Parameter Store Parameters and Verify Secrets Manager Secret
Let's create our hidden values and plaintext parameters.

1. Navigate to **Parameter Store** in a new tab.

2. Click **Create Parameter**.

3. Create the following **2** parameters from the table below. You can get your `wordpress` database endpoint from the `Connectivity & security` section of the RDS page.

| NAME                   | DESCRIPTION                 | TIER     | DATA TYPE | VALUE                                                                                                                                                               |
| ---------------------- | --------------------------- | -------- | --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| /dev/WORDPRESS_DB_HOST | Wordpress RDS endpoint      | Standard | text      | YOUR_RDS_ENDPOINT:3306 (Example: [wordpress-rds.cc5tzmus2oai.us-east-1.rds.amazonaws.com:3306](http://wordpress-rds.fasdf34fas.us-east-1.rds.amazonaws.com:3306)) |
| /dev/WORDPRESS_DB_NAME | Wordpress RDS Database Name | Standard | text      | wordpress                                                                                                                                                           |

4. Once you have created the parameters above, open **AWS Secrets Manager** in a new tab.

5. Verify there is a new secret there with a naming convention similar to _rds!db-1380b131-f0b2-4ef3-833f-4ab7a78f29fd_.

6. Select the secret, and then find and click on **Retrieve secret value** to view your admin credentials.

7. To ensure this is the latest version, click on the **Versions** tab and make sure there is only one _AWSCURRENT_ tag.

8. Leave these two tabs open, as we will reference them later on for our containers.

## Create the ECR Repository and Image

1. Navigate to **Elastic Container Registry** in a new tab.

2. Under _Private registry_ on the left-hand side menu, select **Repositories**.

3. Click on **Create repository**.

4. For _Visibility settings_ select **Private**.

5. For _Repository_ name enter `wordpress`.

6. Leave Tag _immutability_ **disabled**.

7. **Enable** the _Scan on _push_ option.

8. Leave _KMS encryption_ **disabled**.

9. Click on **Create repository**.

10. Select your newly created `wordpress` repository.

11. Open a new tab for the **AWS Cloud9** service.


12. Click on **Open in Cloud9** (_Dismiss any message that may popup initially_).

13. Once loaded, select and expand the bottom terminal session.

14. Now, navigate to **AWS IAM** in a new tab.

15. Find and select **Users** from the menu.

17. Find your `cloud_user` and select it.

18. Click on **Security Credentials**.

19. Under _Access keys_, click on **Create access key**.

20. Select the **Command Line Interface (CLI)** radio button and click the box to confirm you understand the recommendations.

21. Click **Next**.

22. Enter your own description tag value and click **Create access key**.

23. Under the _Retrieve access keys_ page, copy the **Access key** value, then navigate back to your Cloud9 tab.

24. In Cloud9, run `aws configure --profile cloud_user`.

25. Paste in your **Access key** and hit enter.

26. Go back to your IAM access key tab and then copy the **Secret access key** value.

27. Navigate back to Cloud9 and paste in the value, then hit enter.

28. Set the default region to `us-east-1`.

29. Set default output to `json`.

30. If you get a popup about _AWS managed temporary credentials_, select **Cancel** and then **Re-enable after refresh**.

31. Test that you can perform an AWS CLIv2 command (Example: `aws s3 ls --profile cloud_user`).

32. Leave your Cloud9 tab running, and Navigate back to the **ECR tab**.

33. Click on **View push commands**.

34. Copy and paste **Step 1** into your Cloud9 terminal. Before entering, add the `--profile cloud_user` to the portion before the pipe. Example below:

```bash
    aws ecr get-login-password --region us-east-1 --profile cloud_user | docker login --username AWS --password-stdin <ecr_registry_url>
```
35. You should see a **Login Succeeded** message.

36. Pull the latest Docker image for WordPress running this command:

   ```bash
   docker pull wordpress:latest
   ```
37. Once complete, tag the image we want to push by copying and pasting **Step 3** from the ECR push commands prompt. (_We don't need to run Step 2 because the image is already built_).

38. Verify the new image exists locally by running the following command:

    ```bash
    docker image ls
    ```

39. Now run **Step 4** from the ECR push commands.

It should push our new image to ECR, which you can verify in the ECR console after completion.

After verifying the image is in place, leave the ECR tab open and then move on to the next section!

## Create the Amazon ECS Task Definition
1. Navigate to the **Amazon ECS** service in a new tab.

2. Once there, find and select **Task definitions** from the left-hand menu.

3. Click on **Create new task definition**.

4. Enter `wordpress-td` for the _Task definition family_.

5. Under _Infrastructure requirements_, for _Launch type_, select **AWS Fargate**.

6. Leave the other defaults as-is, and then select **OurEcsTaskRole** for the _Task role_.

7. For the _Task execution role_, find and select the already created role called `OurEcsTaskExecutionRole`.

8. Under _Container - 1_, enter the following settings for _Container details_. You can get your `wordpress` image URI from the ECR page.

| IMAGE     | IMAGE URI                                                                                                                                                                                              | ESSENTIAL CONTAINER |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------- |
| wordpress | Your ECR Image URI from the custom image you pushed (Example: [_25974.dkr.ecr.us-east-1.amazonaws.com/wordpress:latest_](http://295974.dkr.ecr.us-east-1.amazonaws.com/wordpress:latest)) | Yes                 |

9. Leave the other defaults and find the _Environment variables_ section.

10. Click on **Add environment variable** and then fill in the information for each of the below **4** variables. **PLEASE NOTE THE ARN SYNTAX OF THE SECRETS MANAGER SECRET**.

| **KEY**               | **VALUE TYPE** | **VALUE**                                                                                                                                                                                                                                       |
| --------------------- | -------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| WORDPRESS_DB_HOST     | ValueFrom      | ARN of the respective Parameter Store parameter (Example: _arn:aws:ssm:us-east-1:556824:parameter/dev/WORDPRESS_DB_HOST_                                                                                                                        |
| WORDPRESS_DB_NAME     | ValueFrom      | ARN of the respective Parameter Store parameter (Example: _arn:aws:ssm:us-east-1:5556824:parameter/dev/WORDPRESS_DB_NAME_                                                                                                                       |
| WORDPRESS_DB_USER     | ValueFrom      | ARN of the respective Secrets Manager RDS secret, specifying the specific key value by adding `:username::` at the end (Example: _arn:aws:secretsmanager:us-east-1:556824:secret:rds!db-1380b131-f0b2-4ef3-833f-4ab7a78f29fd-BAsjMA:username::_ |
| WORDPRESS_DB_PASSWORD | ValueFrom      | ARN of the respective Secrets Manager RDS secret, specifying the specific key value by adding `:password::` at the end (Example: _arn:aws:secretsmanager:us-east-1:556824:secret:rds!db-1380b131-f0b2-4ef3-833f-4ab7a78f29fd-BAsjMA:password::_ |

11. Click on **Create** at the bottom.

## Create the ECS Cluster and Service

1. Within the ECS service, find and select **Clusters**.

2. Click **Create cluster**.

3. For _Cluster name_ enter `Wordpress-Cluster`.

4. Under **Infrastructure**, select `AWS Fargate (serverless)`.

5. Click on **Create**.

6. Wait for your cluster to be created before moving on. If you get any service related errors, please navigate to the CloudFormation template that is created for you by the service and retry the deployment.

7. Select your **Wordpress-Cluster**.

8. Under the _Services_ tab, click on **Create**.

9. For _Compute options_ select **Launch type**.

10. Make sure the _Launch type_ is set to **FARGATE**.

11. Make sure _Platform_ _version_ is set to **LATEST**.

12. Move to _Deployment configuration_.

13. For _Application type_ select **Service**.

14. For _Family_, under _Task definition_, choose your `wordpress-td` task definition from the dropdown and use the `LATEST` version.

15. Name your service `wordpress-service`.

16. Set desired tasks to `1`.

17. Skip to the _Networking_ section and select **Your Custom VPC**.

18. For _Subnets_, click **Clear current selection** and only select the ones titled **Private Subnet**.

19. Choose **Create a new security group** for _Security group_.

20. Name it `app-sg` and give it your description of choice.

21. For _Inbound rules for security groups_, allow port `80`

22. Set _Public IP_ to be turned **off**.

23. Move to _Load balancing_, for _Load balancer type_, select **Application Load Balancer**.

24. Choose **Use an existing load balancer**.

25. Find the load balancer named `OurApplicationLoadBalancer`.

26. Set the _Health check grace_ _period_ to `30 seconds`.

27. Leave the _Listener_ values as default.

28. For _Target group_, name it `wordpress-tg`.

29. _For the Health check path_, enter 
`/wp-admin/images/wordpress-logo.svg`. (_We do this because we are needing to set up WP still. Otherwise, it will fail the initial health check_).

30. Leave the rest of the values as the defaults.

31. Skip to the bottom and select **Create**.

32. Wait until your service is up and running, then you can move on!

## Connect to the Application

1. Once you have a service up and running, you should see a task listed under the Tasks tab within the cluster.
2. Navigate to the **Amazon EC2** console.
3. Find and select **Load balancer**.
4. Find the `OurApplicationLoadBalancer` and choose it.
5. Now, copy and paste your ALB DNS name into a new tab, ensuring you use **HTTP**.
6. You should be greeted by the Wordpress setup page!
