## Automating EBS Snapshot Creation with EventBridge Event and SNS
![image](../images/sns-hol.jpg)

Log in to the live AWS environment using the credentials provided. Make sure you're in the N. Virginia (`us-east-1`) region throughout the lab.

**Note: Please delete your email in the SNS section before closing the lab.**

## Create One (1) SNS Topic with One (1) SNS Subscription

1. Navigate to SNS using the _Services_ menu or the unified search bar.
2. On the SNS page, in the _Create topic box_, give it a topic name of `EBSSnap`.
3. Click **Next step**.
4. Accept the defaults on the _Create topic_ page and click **Create topic**.
5. Click **Create Subscription**.
6. Set the Protocol to **Email**.
7. For _Endpoint_, enter your email address.
8. Click **Create subscription**.
9. Check your email inbox and confirm the subscription in the email you received.

## Create One (1) EventBridge Rule
1. Navigate to EC2 and select **Volumes** in the sidebar menu.
2. Select any of the listed volumes.
3. In the _Description_ section below, copy its volume ID to your clipboard.
4. Navigate to CloudWatch. Below _Events_ in the sidebar menu, select **Rules**.
5. Click **Create rule** at the top of the console.
6. Set the Event Source to **Schedule**, and set the following value:
    * _Fixed rate of_: **1 Days**
7. Click *Add target*.
8. Use the main dropdown to choose **EC2 CreateSnapshot API call**, then paste in the volume ID from your clipboard.
9. Select **Create a new role for this specific resource** with the predefined name.
10. Click **Add target**.
11. Use the main dropdown to choose **SNS topic**, and select our newly created EBSSnap SNS topic.
12. Click **Configure details**.
13. Give the rule a name of `EBSSnap`.
14. Make sure State is set to **Enabled**, and click **Create rule**.
## Verify One (1) EBS Snapshot Has Been Created
1. Check your inbox for the message from SNS.
2. After about a minute, check in **EC2** > **Snapshots** that a new snapshot has been created.