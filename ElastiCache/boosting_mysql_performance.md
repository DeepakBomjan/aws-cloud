## Boosting MySQL database performance
https://aws.amazon.com/getting-started/hands-on/boosting-mysql-database-performance-with-amazon-elasticache-for-redis/

## Command to setup EC2 Instance
```bash
sudo yum install git -y
sudo yum install mysql -y
sudo yum install python3 -y
sudo yum install python3-pip -y
pip3 install --user virtualenv
git clone https://github.com/aws-samples/amazon-elasticache-samples/
cd amazon-elasticache-samples/database-caching
virtualenv venv
source ./venv/bin/activate
pip3 install -r requirements.txt
```

## Install MySQL client
```bash
apt-get install mysql-client
```

## Install python pip
```bash
sudo apt install python3-pip
```

## Add table in db
```bash
mysql -h endpoint -P 3306 -u admin -p < seed.sql
```
##  Connect to your database
```bash
mysql -h endpoint -P 3306 -u admin -p
```
## Create a database and populate 
```sql
CREATE database tutorial;

USE tutorial;

CREATE TABLE planet (id INT UNSIGNED AUTO_INCREMENT,name VARCHAR(30),PRIMARY KEY(id));
INSERT INTO planet (name) VALUES ("Mercury");
INSERT INTO planet (name) VALUES ("Venus");
INSERT INTO planet (name) VALUES ("Earth");
INSERT INTO planet (name) VALUES ("Mars");
INSERT INTO planet (name) VALUES ("Jupiter");
INSERT INTO planet (name) VALUES ("Saturn");
INSERT INTO planet (name) VALUES ("Uranus");
INSERT INTO planet (name) VALUES ("Neptune");
```
## Show databases;
```sql
SHOW DATABASES;
USE <database>;
SHOW TABLES;

```

## Test connection with redis node
```bash
python3.10
import redis
client = redis.Redis.from_url('redis://endpoint:6379')
client.ping()

```

## Configure environment
```bash
export REDIS_URL=redis://test-cache-isrefg.serverless.use1.cache.amazonaws.com:6379:6379/
export DB_HOST=database-1.cdluugkb6yss.us-east-1.rds.amazonaws.com
export DB_USER=admin
export DB_PASS=changeme
export DB_NAME=tutorial
```