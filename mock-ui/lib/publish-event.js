const aws = require('aws-sdk');

aws.config.update({
  endpoint: 'http://172.17.0.1:4566',
  region: 'eu-west-2',
});

module.exports = async (eventObject) => new aws
  .SNS()
  .publish({
    Message: JSON.stringify(eventObject),
    TopicArn: 'arn:aws:sns:eu-west-2:000000000000:MY-T',
  })
  .promise();
