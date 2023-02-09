# Lambda Local Environment

This repo is an example of how to pass a message to an AWS SNS topic/SQS queue and have that message processed by an AWS Lambda function.

The end to end process shown here has a mock user interface for sending the messages and a mock endpoint for the lambda to call.

Since running the end to end process zips up the lambda for copying to an S3 bucket, it doesn't make for a quick development experience if you wanted to try something out, or more easily view logs.

With that in mind, a pared down process can also be used to set up the SNS topic/SQS queue without registering the lambda.

## Environmental Variables

In order for this to run, set:

```
export NODE_VERSION=18.14.0-alpine3.17
```

Or whichever node/alpine version you'd prefer; using a lower version may cause some packages in the Dockerfile to need changing.

## Running

To run all services needed for the end to end process:

```
make all
```

The mock-ui should then be available at:

```
http://localhost:3001
```

To run all services needed for the pared down process:

```
make some
```

Then to run the lambda with the seeded messages:

```
npm i && npm start
```

## Useful Commands

The RedrivePolicy used when provisioning the SQS queue sets `maxReceiveCount` to 3, so when the lambda fails 3 times (i.e. `throw new Error('AHHH!)`) the letter will be moved to the Dead Letter Queue.

Using either of the above methods of running a service, you can check the AWS services provisioned in localstack using the below, along with the status of letters in those respective queues (the`ApproximateNumberOfMessages...` properties):

```
aws sqs list-queues \
  --endpoint-url=http://localhost:4566

aws sqs get-queue-attributes \
  --endpoint-url=http://localhost:4566 \
  --queue-url=http://localhost:4566/000000000000/MY-Q \
  --attribute-names=All

aws sqs get-queue-attributes \
  --endpoint-url=http://localhost:4566 \
  --queue-url=http://localhost:4566/000000000000/MY-DLQ \
  --attribute-names=All
```

Similarly, using either method, messages can be manually added to the queue using:

```
aws sns publish \
  --endpoint-url=http://localhost:4566 \
  --topic-arn=arn:aws:sns:eu-west-2:000000000000:MY-T \
  --message='{"firstname":"Rick","lastname":"Sanchez"}'

aws sqs send-message \
  --endpoint-url=http://localhost:4566 \
  --queue-url=http://localhost:4576/000000000000/MY-Q \
  --message-body='{"Message":"{\"firstname\":\"Morty\",\"lastname\":\"Smith\"}"}'
```

> NOTE: a message to the SNS topic gets wrapped before being passed to the SNS queue, hence a message directly to the SQS queue, as shown above, should be wrapped similarly (i.e. a stringified JSON object as the Message property of a stringified JSON object).

Using the end to end method, logs for the lambda can be accessed using:

```
aws logs tail /aws/lambda/MY-LAMBDA \
  --endpoint-url=http://localhost:4566
```
