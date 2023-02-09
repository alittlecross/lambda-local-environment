const aws = require('aws-sdk');

aws.config.update({
  endpoint: 'http://172.17.0.1:4566',
  region: 'eu-west-2',
});

module.exports = async (ReceiptHandle) => new aws
  .SQS()
  .deleteMessage({
    QueueUrl: 'http://localhost:4566/000000000000/MY-Q',
    ReceiptHandle,
  })
  .promise();
