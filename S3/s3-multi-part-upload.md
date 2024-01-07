## Create large file
```bash 
head -c 10G /dev/urandom > sample.txt
fallocate -l 1G test.img
dd if=/dev/zero of=1g.img bs=1 count=0 seek=1G
dd if=/dev/zero of=1g.bin bs=1G count=1
```

## Split Files
```bash
split -l 10 filename
split <file> -b 10M 

```
## Create Multipart Upload

We are initiating the multi-part upload using AWS CLI command which will generate a UploadID, which will be later used for uploading chunks.

* Syntax: aws s3api create-multipart-upload --bucket [Bucket name] --key [original file name]
![screenshot1](../screenshots/s3api_screenshot1.jpg)

**Note: Please copy the UploadId into a text file, Like Notepad.**

![screenshot2](../screenshots/s3api_screenshot2.jpg)

* Syntax: aws s3api upload-part --bucket [bucketname] --key [filename] --part-number [number] --body [chunk file name] --upload-id [id]
* Example: aws s3api upload-part --bucket s3multipart-final --key video.mp4 --part-number 1 --body xaa --upload-id
![screenshot3](../screenshots/s3api_screenshot3.jpg)

Note: Copy the ETag id and Part number to your Notepad in your local machine.

* Now repeat the above CLI command for each chunk file [Replace --part-number & --body values with the above table values]

### Create a Multipart JSON file 
Create a file with all part numbers with their Etag values.

1. Creating a file named list.json

2. Copy the below JSON Script and paste it in the list.json file.
![screenshot4](../screenshots/s3api_screenshot4.jpg)
3. Save the File list.json

### Complete Multipart Upload
Now we are going to join all the chunks/split files together with the help of the JSON file we created in the above step.

* Syntax: aws s3api complete-multipart-upload --multipart-upload [json file link] --bucket [upload bucket name] --key [original file name] --upload-id [upload id]

![screenshot4](../screenshots/s3api_screenshot5.jpg)


## Using aws s3 cli

```bash
aws s3 cp large_test_file s3://DOC-EXAMPLE-BUCKET/
```
## Set concurrency
```bash
aws configure set default.s3.max_concurrent_requests 20
```

## Use low-level aws s3api commands
https://repost.aws/knowledge-center/s3-multipart-upload-cli


### Commands
```bash
aws s3api create-multipart-upload --bucket DOC-EXAMPLE-BUCKET --key large_test_file
```
1. Split large file
```bash
# Syntax: split -b byte_count[K|k|M|m|G|g] [file] [prefix]
split -b 100M OSR507V_vmware_1.0.0Di.iso ./OSR507V_vmware_1.0.0Di.iso
```

2. Run the following command to initiate a multipart upload and to retrieve the associated upload ID. The command returns a response that contains the **UploadID**:

```bash
% aws s3api create-multipart-upload --bucket testing234123241423 --key OSR507V_vmware_1.0.0Di.iso
{
    "ServerSideEncryption": "AES256",
    "Bucket": "testing234123241423",
    "Key": "OSR507V_vmware_1.0.0Di.iso",
    "UploadId": "4VUqRgZUEJNaH3Kx_atia0VhS5yHFXy9Lhs2nZPK7vf7ie3ECSnTUF0YLFVP15eVACi69agkeQlHtOfbxAHrDIuTr_bELhYvzxASh8B0wdCeJfy8Idf7NK8H_2_BUg.I"
}
```
3. Run the following command to upload the first part of the file. Replace all values with the values for your bucket, file, and multipart upload. The command returns a response that contains an **ETag** value for the part of the file that you uploaded. 
```bash
 aws s3api upload-part --bucket testing234123241423 --key OSR507V_vmware_1.0.0Di.iso --part-number 1 --body OSR507V_vmware_1.0.0Di.isoaa --upload-id 4VUqRgZUEJNaH3Kx_atia0VhS5yHFXy9Lhs2nZPK7vf7ie3ECSnTUF0YLFVP15eVACi69agkeQlHtOfbxAHrDIuTr_bELhYvzxASh8B0wdCeJfy8Idf7NK8H_2_BUg.I

{
    "ServerSideEncryption": "AES256",
    "ETag": "\"ab47a9ed63009ce441aa366dc51f94cb\""
}
```

4. list parts
```bash
aws s3api list-multipart-uploads --bucket  testing234123241423
```
5. After you upload all the file parts, run the following command to list the uploaded parts and confirm that the list is complete:
```bash
aws s3api list-parts --bucket testing234123241423 --key OSR507V_vmware_1.0.0Di.iso --upload-id 4VUqRgZUEJNaH3Kx_atia0VhS5yHFXy9Lhs2nZPK7vf7ie3ECSnTUF0YLFVP15eVACi69agkeQlHtOfbxAHrDIuTr_bELhYvzxASh8B0wdCeJfy8Idf7NK8H_2_BUg.I

```
6. Compile the ETag values for each file part that you uploaded into a JSON-formatted file.
```bash

{
    "Parts": [
        {
            "PartNumber": 1,
            "ETag": "ab47a9ed63009ce441aa366dc51f94cb",
        },
        {
            "PartNumber": 8,
            "ETag": "019387cec8eaf0fdb0c922337429669a",
        },
        {
            "PartNumber": 9,
            "ETag": "aa1f9bfd6346f2b7d5373678069bb55c",
        },
        {
            "PartNumber": 10,
            "ETag": "6eaadb0b242eedb45e317b91c679e9fd",
        },
        {
            "PartNumber": 11,
            "ETag": "193789939516b89b74ab20ac5724b3c5",
        },
        {
            "PartNumber": 12,
            "ETag": "0787ec49c727d308b8b624d4e872990c",
        },
        {
            "PartNumber": 13,
            "ETag": "4a28537f6df05eb9a48c8f25136543d0",
        }
    ]
}
```
6. Run the following command to complete the multipart upload. Replace the value for --multipart-upload with the path to the JSON-formatted file with ETags that you created
```bash
 aws s3api complete-multipart-upload --multipart-upload file://file_parts.json --bucket testing234123241423 --key OSR507V_vmware_1.0.0Di.iso --upload-id 4VUqRgZUEJNaH3Kx_atia0VhS5yHFXy9Lhs2nZPK7vf7ie3ECSnTUF0YLFVP15eVACi69agkeQlHtOfbxAHrDIuTr_bELhYvzxASh8B0wdCeJfy8Idf7NK8H_2_BUg.I
{
    "ServerSideEncryption": "AES256",
    "Location": "https://testing234123241423.s3.us-east-1.amazonaws.com/OSR507V_vmware_1.0.0Di.iso",
    "Bucket": "testing234123241423",
    "Key": "OSR507V_vmware_1.0.0Di.iso",
    "ETag": "\"04f593e3e674d6488115398478229355-7\""
}

```

## Byte-range fetch

```bash
 aws s3api get-object \
    --bucket testingbucket123142352 \
    --key index.html \
    --range "bytes=1-20" \
    output.txt
{
    "AcceptRanges": "bytes",
    "LastModified": "2023-12-24T22:06:09+00:00",
    "ContentLength": 1000,
    "ETag": "\"04f593e3e674d6488115398478229355-7\"",
    "ContentRange": "bytes 1000-1999/726966272",
    "ContentType": "binary/octet-stream",
    "ServerSideEncryption": "AES256",
    "Metadata": {}
}
```
## Using curl
```bash
#!/bin/sh 
outputFile="/PATH/TO/LOCALLY/SAVED/FILE"
amzFile="BUCKETPATH/TO/FILE"
region="YOUR-REGION"
bucket="SOME-BUCKET"
resource="/${bucket}/${amzFile}"
contentType="binary/octet-stream"
dateValue=`TZ=GMT date -R`
# You can leave our "TZ=GMT" if your system is already GMT (but don't have to)
stringToSign="GET\n\n${contentType}\n${dateValue}\n${resource}"
s3Key="ACCESS_KEY_ID"
s3Secret="SECRET_ACCESS_KEY"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${s3Secret} -binary | base64`
curl -H "Host: s3-${region}.amazonaws.com" \
     -H "Date: ${dateValue}" \
     -H "Content-Type: ${contentType}" \
     -H "Authorization: AWS ${s3Key}:${signature}" \
     https://s3-${region}.amazonaws.com/${bucket}/${amzFile} -o $outputFile

```

Ref:
https://stackoverflow.com/questions/30876123/script-to-download-file-from-amazon-s3-bucket





for part in $(ls OSR507V_vmware_1.0.0Di.isoa*)
do
echo "uploading $part ..."
aws s3api upload-part --bucket testingbucket123142352 --key OSR507V_vmware_1.0.0Di.iso --part-number $c --body $part --upload-id crjyVO.7YjemaLKv2Q5qFYO8eWX92MxivHjo0IGide_LbUPZ3cgckfJ3dVnvcse3_X0dxiJnFI4irBy_1oujBej65o.750cbyazNFIWbbbY00jmRfLRX6yL3gn8npf5G
c=$((c+1))
done
