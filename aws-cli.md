# AWS CLI
## Get help with the AWS CLI

```
aws help
aws ec2 help
aws ec2 describe-instances help
```

## Command structure in the AWS CLI

```
aws <command> <subcommand> [options and parameters]
```
1. aws binary
2. service(command)
3. Operation(Subcommand)
4. options or parameters required by the operation

```
aws s3 ls
aws cloudformation create-change-set --stack-name my-stack --change-set-name my-change-set
```

## Setup AWS Credential and Profile
### Environment variables to configure the AWS CLI
```
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
export AWS_DEFAULT_REGION=us-west-2
```

```
aws configure --profile <profile_name>

aws configure list-profiles

aws configure --profile <profile_name>		## update aws profile

```

