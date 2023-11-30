import boto3

# AWS IAM policy details
policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"  # Example policy, replace with the desired policy ARN

# Number of users to create
num_users = 3

# Create IAM service resource
iam = boto3.resource('iam')

# Loop to create multiple users
for i in range(1, num_users + 1):
    username = f"iamuser{i}"
    password = "user@123"  # Replace with the desired initial password

    # Create IAM user
    user = iam.create_user(UserName=username)

    # Attach a policy to the user (AdministratorAccess in this example)
    user.attach_policy(PolicyArn=policy_arn)

    # Create login profile with initial password
    user.create_login_profile(Password=password, PasswordResetRequired=True)

    # Create access key and secret key for the user
    access_keys = user.create_access_key_pair()

    # Display user details
    print(f"IAM User Created:")
    print(f"Username: {username}")
    print(f"Access Key ID: {access_keys.id}")
    print(f"Secret Access Key: {access_keys.secret}")
    print(f"Initial Password: {password}")
    print("-----------------------")
