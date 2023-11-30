#!/bin/bash

# Loop to delete users starting with "user"
for i in {1..5}; do
  USERNAME="iamuser$i"

  # Remove access keys
  aws iam list-access-keys --user-name $USERNAME | jq -r '.AccessKeyMetadata[] | .AccessKeyId' | \
    xargs -I {} aws iam delete-access-key --user-name $USERNAME --access-key-id {}

  # Remove login profile
#   aws iam delete-login-profile --user-name $USERNAME

  # Detach policies
  aws iam list-attached-user-policies --user-name $USERNAME | jq -r '.AttachedPolicies[] | .PolicyArn' | \
    xargs -I {} aws iam detach-user-policy --user-name $USERNAME --policy-arn {}

  # Remove inline policies
  aws iam list-user-policies --user-name $USERNAME | jq -r '.PolicyNames[]' | \
    xargs -I {} aws iam delete-user-policy --user-name $USERNAME --policy-name {}

  # Delete the user
  aws iam delete-user --user-name $USERNAME

  echo "User $USERNAME deleted."
done
