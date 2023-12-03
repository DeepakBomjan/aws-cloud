
**Install awscli**
```bash
brew install awscli
```

**Configure AWS**
Create and download your credentials from AWS Web Console, then configure AWS on your machine
```console
$ aws configure
AWS Access Key ID [None]: access-id-here
AWS Secret Access Key [None]: secret-key-here
Default region name [None]: region-name (us-west-2)
Default output format [None]: json
```

**General Command Structure**
```bash
aws <command> <subcommand> [options and parameters]
```
```bash
aws <command> help
```
```bash
aws <command> <subcommand> help
```

**List all buckets**
```bash
aws s3 ls
```

**List all objects in a bucket**
```bash
aws s3 ls s3://<name-of-bucket>
```

**Copy object to a bucket**
```bash
aws s3 cp <my-local-object> s3://<destination-bucket>
```

**Copy object from a bucket to a local destination**
```bash
aws s3 cp s3://<destination-bucket>/<object-key> <local-destination>
```

**Remove object from a bucket**
```bash
aws s3 rm s3://<name-of-bucket>/<object-key>
```

**Make a new bucket**
```bash
aws s3 mb s3://<name-of-bucket>
```

**Remove a bucket**
```bash
aws s3 rb s3://<name-of-bucket>
```

**Sync a bucket to local**
```bash
aws s3 sync <my-local-folder> s3://<name-of-bucket>
```

**Get the details of an object in an S3 bucket given its object-key**
```bash
aws s3api head-object --bucket <name-of-bucket> --key <object-key>
```

**Filter by `prefix` the list of objects fron an S3 bucket**
```bash
aws s3api list-objects-v2 --bucket <name-of-bucket> --prefix <object-key>
```

**Filter by `Size` the list of objects in an S3 bucket**

In this case, get all the Object `key`s with less than 2KB

```bash
aws s3api list-objects-v2 --bucket <name-of-bucket> --query ‘Contents[?Size<`2000`].[Key]’
```

**Filter by `Size` and `LastModified`, the list of objects in an S3 bucket**

In this case, get all the Object `key`s with less than 2KB and lastmodified on or later `2021-06-21T00:00:00`

```bash
aws s3api list-objects-v2 --bucket <name-of-bucket> --query ’Contents[?(Size<=`2000` && LastModified>=`2021-06-21T00:00:00`)].[Key,Size]
```
