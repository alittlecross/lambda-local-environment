const axios = require('axios');

const { findOne, insertOne } = require('./lib/mongo-database');
const { host } = require('./config');

const deleteMessage = require('./lib/delete-message');

const handler = async (event) => {
  for (let i = 0; i < event.Records.length; i++) {
    const { body, messageId, receiptHandle } = event.Records[i];

    try {
      const document = await findOne(messageId);

      if (document) {
        console.log(`Message ID (${messageId}) already exists`);
      } else {
        const { status } = await axios({
          method: 'post',
          url: `http://${host}:3000/my-endpoint`,
          data: JSON.parse(JSON.parse(body).Message),
        });

        if (status === 200) {
          await deleteMessage(receiptHandle);
          await insertOne(messageId);

          console.log(`Message ID (${messageId}) added to database`);
        }
      }
    } catch (err) {
      console.error(err);
    }
  }
};

module.exports = {
  handler,
};
