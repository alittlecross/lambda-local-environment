const { MongoClient } = require('mongodb');

const { host } = require('../config');

const client = new MongoClient(`mongodb://${host}:27017`);

const connect = async (cb) => {
  let response;

  try {
    await client.connect();

    const db = client.db('MY-DB');
    const collection = db.collection('MY-C');

    response = await cb(collection);
  } finally {
    await client.close();
  }

  return response;
};

const findOne = async (messsageId) => connect(async (collection) => collection.findOne({
  messsageId,
}));

const insertOne = async (messsageId) => connect(async (collection) => collection.insertOne({
  messsageId,
}));

module.exports = {
  findOne,
  insertOne,
};
