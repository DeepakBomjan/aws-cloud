## Simple Event-Driven App using Amazon MQ (RabbitMQ)

[gitHub link](https://github.com/bervProject/rabbitmq-demo/tree/main)

### Prepare the RabbitMQ in Amazon MQ
1. Select `RabbitMQ` and __click Next__.
2. We will use __Single-instance broker__ just for testing, you may use _Cluster deployment_ for production use. And, **click Next**.
3. Give the broker name and select **mq.t3.micro** instance.
4. Setup the **username** and **password** for the RabbitMQ host.
5. Open the **Additional setting**. Make sure you select the Public access and **Use the default VPC and subnet(s)**. Please avoid Public access for production use. You may need to use **Private access** and setup the VPC yourself for production use.
6. Finally, click **Next**. Review your configuration, and click **Create broker**.
## Time to Code!
1. Init your project. Use ```yarn init```. Input the details of your project.
2. Install some dependencies.
    * ```yarn add amqplib``` - for send/consume message from/to RabbitMQ.
    * ```yarn add uuid``` - to generate message id and correlation id.
## Sender Code
```javascript
const amqp = require('amqplib');
const { v4: uuidv4 } = require('uuid');

// setup queue name
const queueName = 'test-queue';

/**
 * Send message
 */
async function send() {
  // connect to RabbitMQ
  const connection = await amqp.connect(process.env.RABBITMQ_HOST || 'amqp://localhost');
  // create a channel
  const channel = await connection.createChannel();
  // create/update a queue to make sure the queue is exist
  await channel.assertQueue(queueName, {
    durable: true,
  });
  // generate correlation id, basically correlation id used to know if the message is still related with another message
  const correlationId = uuidv4();
  // send 10 messages and generate message id for each messages
  for (let i = 1; i <= 10; i++) {
    const buff = Buffer.from(JSON.stringify({
      test: `Hello World ${i}!!`
    }), 'utf-8');
    const result = channel.sendToQueue(queueName, buff, {
      persistent: true,
      messageId: uuidv4(),
      correlationId: correlationId,
    });
    console.log(result);
  }
  // close the channel
  await channel.close();
  // close the connection
  await connection.close();
}

send();
```

## Consumer Code
```javascript
const amqp = require('amqplib');

// setup queue name
const queueName = 'test-queue';

/**
 * consume the message
 */
async function consume() {
  // setup connection to RabbitMQ
  const connection = await amqp.connect(process.env.RABBITMQ_HOST || 'amqp://localhost');
  // setup channel
  const channel = await connection.createChannel();
  // make sure the queue created
  await channel.assertQueue(queueName, {
    durable: true,
  });
  console.log(" [*] Waiting for messages in %s. To exit press CTRL+C", queueName);
  // setup consume
  channel.consume(queueName, function (message) {
    // just print the message in the console
    console.log("[%s] Received with id (%s) message: %s", message.properties.correlationId, message.properties.messageId, message.content.toString());
    // ack manually
    channel.ack(message);
  }, {
    // we use ack manually
    noAck: false,
  });
}

consume();
```
## Test Your Code
1. Setup your environment variable, you may use the example scripts to setup the environment variable. As example:
```bash
export RABBITMQ_HOST=amqps://<username>:<password>@<rabbitmq-endpoint>:<rabbitmqport>
```
2. Run the sender. Use 
    ```bash
    node sender.js
    ```  
3. Run the consumer
    ```bash
    node consumer.js
    ```

[Lab References](https://dev.to/aws-builders/simple-event-driven-app-using-amazon-mq-rabbitmq-22b0)

[rabbitmq server Client Code with Design pattern and Metaclass](https://github.com/soumilshah1995/rabbitmq-python-server-client/tree/master)