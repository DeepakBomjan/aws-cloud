#!/bin/bash

# AWS IAM policy details
POLICY_ARN="arn:aws:iam::aws:policy/IAMUserChangePassword"  # Example policy, replace with the desired policy ARN

# Loop to create multiple users
for i in {5..6}; do

  USERNAME="iamuser$i"
  PASSWORD="user@123"
  
  # Create IAM user
  aws iam create-user --user-name $USERNAME
  
  # Attach a policy to the user (AdministratorAccess in this example)
  aws iam attach-user-policy --user-name $USERNAME --policy-arn $POLICY_ARN
  
  # Create login profile with initial password
  aws iam create-login-profile --user-name $USERNAME --password $PASSWORD --password-reset-required
  

  # Create access key and secret key for the user
  keys=$(aws iam create-access-key --user-name $USERNAME)
  access_key=$(echo $keys | jq -r '.AccessKey.AccessKeyId')
  secret_key=$(echo $keys | jq -r '.AccessKey.SecretAccessKey')
  
  # Display user details
  echo "IAM User Created:"
  echo "Username: $USERNAME"
  echo "Access Key ID: $access_key"
  echo "Secret Access Key: $secret_key"
  echo "Initial Password: $PASSWORD"
  echo "-----------------------"
done
