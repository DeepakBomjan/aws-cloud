## Install dependency command
```bash
sudo apt-get install --reinstall libpq-dev
python3 -m pip install psycopg2-binary
python3 -m pip install Flask
```

## Install redis-cli
```bash
sudo apt install lsb-release curl gpg
 curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
 echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list

sudo apt-get update
sudo apt-get install redis
```

## check connection
[Connect to the cluster's node](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/GettingStarted.ConnectToCacheNode.html)
```bash
redis-cli --tls -h test-cache-isrefg.serverless.use1.cache.amazonaws.com -p 6379

client = redis.Redis(host='test-cache-isrefg.serverless.use1.cache.amazonaws.com',ssl=True,ssl_ca_certs=None)

```


[Python connection to AWS ElastiCache Redis](https://github.com/cloud-gov/aws-redis-example/tree/main/python)



