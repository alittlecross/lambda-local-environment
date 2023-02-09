const aws = require('aws-sdk');

const { handler } = require('../index');

aws.config.update({
  endpoint: 'http://localhost:4566',
  region: 'eu-west-2',
});

(async () => {
  const { Messages } = await new aws
    .SQS()
    .receiveMessage({
      QueueUrl: 'http://localhost:4566/000000000000/MY-Q',
      MaxNumberOfMessages: 10,
      VisibilityTimeout: 10,
      WaitTimeSeconds: 1,
    })
    .promise();

  console.log(`${Messages?.length || 0} in MY-Q\n`);

  if (Messages) {
    const event = {
      Records: Messages.map((e) => {
        const obj = {};

        const keys = Object.keys(e);

        for (const key of keys) {
          obj[key.charAt(0).toLowerCase() + key.slice(1)] = e[key];
        }

        return obj;
      }),
    };

    await handler(event);
  }
})();
