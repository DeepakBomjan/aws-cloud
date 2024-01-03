## Creating DynamoDB Table
[!Creating DyanamoDB Table](./images/image_1.jpg)
### Create a DynamoDB Table Using the AWS CLI
1. Create table
    ```bash
    aws dynamodb\
        create-table\
            --table-name PetInventory\
            --attribute-definitions\
                AttributeName=pet_species,  AttributeType=S\
                AttributeName=pet_id,   AttributeType=N\
            --key-schema\
                AttributeName=pet_species,  KeyType=HASH\
                AttributeName=pet_id,   KeyType=RANGE\
            --billing-mode PAY_PER_REQUEST
    ```
2. Check the table
    ```bash
    aws dynamodb describe-table     --table-name PetInventory
    ```
3. List tables
    ```bash
    aws dynamodb list-tables
    ```
4. Verify the table was created as requested
    ```bash
    aws dynamodb describe-table     --table-name PetInventory --query   'Table.{PartitionKey:KeySchema[0].    AttributeName,  PartKeyType:AttributeDefinitions[1].  AttributeType,SortKey:KeySchema[1].   AttributeName, SortKeyType:AttributeDefinitions[0]. AttributeType,   BillingMode:BillingModeSummary.    BillingMode}'
    ```
5. Delete the table
    ```bash
    aws dynamodb delete-table   --table-name PetInventory
    ```

## Create a DynamoDB Table with the Python Boto3 SDK
1. Launch Python3
    ```python
    python3
    ```
2. Import boto3
    ```python
    import boto3

    ```
3. Create a client object
    ```python
    ddb = boto3.client('dynamodb')
    ```
4. Create the requested DynamoDB table
    ```python
    createResponse = ddb.create_table(
    AttributeDefinitions=[
        {
            'AttributeName':'pet_species',
            'AttributeType': 'S',
        },
        {
            'AttributeName':'pet_id',
            'AttributeType':'N'
        }
    ],
    KeySchema=[
        {
            'AttributeName':'pet_species',
            'KeyType':'HASH'
        },
        {
            'AttributeName':'pet_id',
            'KeyType':'RANGE'
        },
    ],
    BillingMode = 'PAY_PER_REQUEST',
    TableName='PetInventory'
    )
    ```
5. View the data in the response
    ```python
    print(createResponse)
    ```
6. Narrow the data down to the ```TableDescription```:
    ```python
    createResponse['TableDescription']
    ```
7. Drill further down into the data by adding more keys:
    ```python
    createResponse['TableDescription']['AttributeDefinitions']
    ```
9. Take a look at the key schema:
    ```python
    createResponse['TableDescription']['KeySchema']
    ```
10. Check the table status:
    ```python
    createResponse['TableDescription']['TableStatus']
    ```
11. Look at the billing mode:
    ```python
    createResponse['TableDescription']['BillingModeSummary']
    ```
12. Get the table name:
    ```python
    createResponse['TableDescription']['TableName']
    ```
13. Create the variable to check the current status of the table:
    ```python
    statusResponse = ddb.describe_table(TableName='PetInventory')
    ```
14. Enter the statusResponse variable:
    ```python
    statusResponse
    ```
15. Take a look at what's available:
    ```python
    statusResponse['Table']
    ```
16. Create the variable to list the tables we have available in this region:
    ```python
    listResponse = ddb.list_tables()
    ```
17. Check the table names:
    ```python
    listResponse['TableNames']
    ```
18. Delete the table:
    ```python
    deleteResponse = ddb.delete_table(TableName = 'PetInventory')
    ```


